import Foundation

enum MealTypeFilter: Identifiable, Equatable {
    case all
    case type(MealType)

    nonisolated var id: String {
        switch self {
        case .all:
            "all"
        case .type(let mealType):
            mealType.id
        }
    }

    nonisolated var title: String {
        switch self {
        case .all:
            "All"
        case .type(let mealType):
            mealType.title
        }
    }

    static let allCases: [MealTypeFilter] = [.all] + MealType.allCases.map { .type($0) }
}
