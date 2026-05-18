import Foundation

extension Date {
    func mealTimeText(calendar: Calendar = .current) -> String {
        formatted(date: .omitted, time: .shortened)
    }

    func recentRelativeDayText(calendar: Calendar = .current) -> String? {
        if calendar.isDateInToday(self) {
            return nil
        }

        return formatted(.dateTime.month(.abbreviated).day())
    }

    func metadataDayText(calendar: Calendar = .current) -> String {
        if calendar.isDateInToday(self) {
            return "Today"
        }

        if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }

        return formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
    }
}
