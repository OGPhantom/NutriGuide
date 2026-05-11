import Foundation

enum MacroKind: String, Identifiable {
    case protein
    case fat
    case carbs
    case calories

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .protein:
            "Protein"
        case .fat:
            "Fat"
        case .carbs:
            "Carbs"
        case .calories:
            "Calories"
        }
    }

    nonisolated var unit: String {
        switch self {
        case .calories:
            "kcal"
        case .protein, .fat, .carbs:
            "g"
        }
    }
}
