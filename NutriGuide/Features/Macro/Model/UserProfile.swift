import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: String
    var sex: Sex
    var age: Int
    var heightCentimeters: Double
    var weightKilograms: Double
    var activityLevel: ActivityLevel
    var goal: NutritionGoal
    var createdAt: Date

    init(
        id: String = "default-profile",
        sex: Sex = .male,
        age: Int = 25,
        heightCentimeters: Double = 175,
        weightKilograms: Double = 75,
        activityLevel: ActivityLevel = .lightlyActive,
        goal: NutritionGoal = .maintainWeight,
        createdAt: Date = .now
    ) {
        self.id = id
        self.sex = sex
        self.age = age
        self.heightCentimeters = heightCentimeters
        self.weightKilograms = weightKilograms
        self.activityLevel = activityLevel
        self.goal = goal
        self.createdAt = createdAt
    }
}

extension UserProfile {
    var dailyTargets: MacroTargets {
        let sexOffset = sex == .male ? 5.0 : -161.0
        let basalMetabolicRate = 10 * weightKilograms + 6.25 * heightCentimeters - 5 * Double(age) + sexOffset
        let maintenanceCalories = basalMetabolicRate * activityLevel.multiplier
        let calories = max(1_200, maintenanceCalories * (1 + goal.calorieAdjustment))

        let proteinGrams = weightKilograms * proteinMultiplier
        let fatCalories = calories * 0.25
        let fatGrams = fatCalories / 9
        let proteinCalories = proteinGrams * 4
        let carbGrams = max(0, (calories - proteinCalories - fatCalories) / 4)

        return MacroTargets(
            calories: calories.rounded(),
            protein: proteinGrams.rounded(),
            fat: fatGrams.rounded(),
            carbs: carbGrams.rounded()
        )
    }

    private var proteinMultiplier: Double {
        switch goal {
        case .loseWeight:
            2.0
        case .maintainWeight, .balancedDiet:
            1.6
        case .gainWeight:
            1.8
        }
    }
}
