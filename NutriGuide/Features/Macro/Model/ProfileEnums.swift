import Foundation

enum Sex: String, CaseIterable, Codable, Identifiable {
    case male
    case female

    nonisolated var id: String { rawValue }
}

enum ActivityLevel: String, CaseIterable, Codable, Identifiable {
    case mostlySedentary
    case lightlyActive
    case moderatelyActive
    case veryActive

    nonisolated var id: String { rawValue }

    nonisolated var multiplier: Double {
        switch self {
        case .mostlySedentary:
            1.2
        case .lightlyActive:
            1.375
        case .moderatelyActive:
            1.55
        case .veryActive:
            1.725
        }
    }
}

enum NutritionGoal: String, CaseIterable, Codable, Identifiable {
    case loseWeight
    case maintainWeight
    case gainWeight
    case balancedDiet

    nonisolated var id: String { rawValue }

    nonisolated var calorieAdjustment: Double {
        switch self {
        case .loseWeight:
            -0.15
        case .maintainWeight, .balancedDiet:
            0
        case .gainWeight:
            0.12
        }
    }
}
