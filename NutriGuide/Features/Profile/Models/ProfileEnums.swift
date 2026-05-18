import Foundation

enum Sex: String, CaseIterable, Codable, Identifiable {
    case male
    case female

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .male:
            "Male"
        case .female:
            "Female"
        }
    }
}

enum ActivityLevel: String, CaseIterable, Codable, Identifiable {
    case mostlySedentary
    case lightlyActive
    case moderatelyActive
    case veryActive

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .mostlySedentary:
            "Mostly sedentary"
        case .lightlyActive:
            "Lightly active"
        case .moderatelyActive:
            "Moderately active"
        case .veryActive:
            "Very active"
        }
    }

    nonisolated var preview: String {
        switch self {
        case .mostlySedentary:
            "Little daily movement"
        case .lightlyActive:
            "Some workouts per week"
        case .moderatelyActive:
            "Regular training"
        case .veryActive:
            "High daily output"
        }
    }

    nonisolated var detail: String {
        switch self {
        case .mostlySedentary:
            "Mostly seated day, little movement"
        case .lightlyActive:
            "Some walking or light daily activity"
        case .moderatelyActive:
            "Regular activity or workouts per week"
        case .veryActive:
            "Lots of movement or intense training"
        }
    }

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

    nonisolated var title: String {
        switch self {
        case .loseWeight:
            "Lose weight"
        case .maintainWeight:
            "Maintain weight"
        case .gainWeight:
            "Gain weight"
        case .balancedDiet:
            "Balanced diet"
        }
    }

    nonisolated var detail: String {
        switch self {
        case .loseWeight:
            "Reduce gradually"
        case .maintainWeight:
            "Stay balanced"
        case .gainWeight:
            "Support growth"
        case .balancedDiet:
            "Improve nutrition"
        }
    }

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
