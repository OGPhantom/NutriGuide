import Foundation

struct DiaryCalendarDay: Identifiable, Equatable {
    let date: Date
    let dayNumber: Int
    let isInDisplayedMonth: Bool
    let isSelected: Bool
    let isToday: Bool
    let hasMeals: Bool

    var id: Date { date }
}
