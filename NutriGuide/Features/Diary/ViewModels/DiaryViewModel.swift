import Foundation

@MainActor
@Observable
final class DiaryViewModel {
    var selectedDate: Date
    var displayedMonth: Date
    var selectedMeal: MealEntry?

    private let calendar: Calendar

    init(today: Date = .now, calendar: Calendar = .current) {
        self.calendar = calendar
        let normalizedToday = calendar.startOfDay(for: today)
        selectedDate = normalizedToday
        displayedMonth = calendar.startOfMonth(for: normalizedToday)
    }

    var monthTitle: String {
        displayedMonth.formatted(.dateTime.month(.wide).year())
    }

    var selectedDateTitle: String {
        selectedDate.formatted(.dateTime.weekday(.wide).month(.wide).day())
    }

    func calendarDays(from meals: [MealEntry]) -> [DiaryCalendarDay] {
        let mealDays = Set(meals.map { calendar.startOfDay(for: $0.loggedAt) })
        let monthStart = calendar.startOfMonth(for: displayedMonth)
        let leadingOutsideDays = calendar.mondayFirstLeadingDays(for: monthStart)
        let gridStart = calendar.date(byAdding: .day, value: -leadingOutsideDays, to: monthStart) ?? monthStart

        return (0..<42).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: gridStart) else {
                return nil
            }

            let day = calendar.startOfDay(for: date)

            return DiaryCalendarDay(
                date: day,
                dayNumber: calendar.component(.day, from: day),
                isInDisplayedMonth: calendar.isDate(day, equalTo: displayedMonth, toGranularity: .month),
                isSelected: calendar.isDate(day, inSameDayAs: selectedDate),
                isToday: calendar.isDateInToday(day),
                hasMeals: mealDays.contains(day)
            )
        }
    }

    func mealsForSelectedDay(from meals: [MealEntry]) -> [MealEntry] {
        meals
            .filter { calendar.isDate($0.loggedAt, inSameDayAs: selectedDate) }
            .sorted { $0.loggedAt < $1.loggedAt }
    }

    func selectDay(_ day: DiaryCalendarDay) {
        selectedDate = calendar.startOfDay(for: day.date)
        displayedMonth = calendar.startOfMonth(for: day.date)
    }

    func showPreviousMonth() {
        moveDisplayedMonth(by: -1)
    }

    func showNextMonth() {
        moveDisplayedMonth(by: 1)
    }

    func selectMeal(_ meal: MealEntry) {
        selectedMeal = meal
    }

    private func moveDisplayedMonth(by monthOffset: Int) {
        let selectedDayNumber = calendar.component(.day, from: selectedDate)
        let nextMonth = calendar.date(byAdding: .month, value: monthOffset, to: displayedMonth) ?? displayedMonth
        displayedMonth = calendar.startOfMonth(for: nextMonth)
        selectedDate = calendar.dateInDisplayedMonth(displayedMonth, preservingDay: selectedDayNumber)
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components).map { startOfDay(for: $0) } ?? startOfDay(for: date)
    }

    func mondayFirstLeadingDays(for monthStart: Date) -> Int {
        let weekday = component(.weekday, from: monthStart)
        return (weekday + 5) % 7
    }

    func dateInDisplayedMonth(_ displayedMonth: Date, preservingDay day: Int) -> Date {
        let dayRange = range(of: .day, in: .month, for: displayedMonth)
        let safeDay = min(day, dayRange?.count ?? day)
        var components = dateComponents([.year, .month], from: displayedMonth)
        components.day = safeDay
        return date(from: components).map { startOfDay(for: $0) } ?? startOfDay(for: displayedMonth)
    }
}
