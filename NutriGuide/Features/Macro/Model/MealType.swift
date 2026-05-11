import Foundation

enum MealType: String, CaseIterable, Codable, Identifiable {
    case breakfast
    case lunch
    case dinner
    case snacks

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .breakfast:
            "Breakfast"
        case .lunch:
            "Lunch"
        case .dinner:
            "Dinner"
        case .snacks:
            "Snacks"
        }
    }

    nonisolated var foodSymbol: String {
        switch self {
        case .breakfast:
            "cup.and.saucer"
        case .lunch:
            "fork.knife"
        case .dinner:
            "takeoutbag.and.cup.and.straw"
        case .snacks:
            "carrot"
        }
    }

    nonisolated static func suggested(for date: Date, calendar: Calendar = .current) -> MealType {
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 5..<11:
            return .breakfast
        case 11..<16:
            return .lunch
        case 16..<22:
            return .dinner
        default:
            return .snacks
        }
    }
}
