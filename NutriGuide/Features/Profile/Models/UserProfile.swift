import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: String
    var displayNameValue: String?
    var sex: Sex
    var age: Int
    var heightCentimeters: Double
    var weightKilograms: Double
    var activityLevel: ActivityLevel
    var goal: NutritionGoal
    var unitSystemRawValue: String?
    var targetCaloriesValue: Double?
    var targetProteinValue: Double?
    var targetFatValue: Double?
    var targetCarbsValue: Double?
    var createdAt: Date

    init(
        id: String = "default-profile",
        displayName: String = "Bohdan",
        sex: Sex = .male,
        age: Int = 25,
        heightCentimeters: Double = 180,
        weightKilograms: Double = 80,
        activityLevel: ActivityLevel = .lightlyActive,
        goal: NutritionGoal = .maintainWeight,
        unitSystem: UnitSystem = .metric,
        targetCalories: Double? = nil,
        targetProtein: Double? = nil,
        targetFat: Double? = nil,
        targetCarbs: Double? = nil,
        createdAt: Date = .now
    ) {
        let calculatedTargets = Self.calculateTargets(
            sex: sex,
            age: age,
            heightCentimeters: heightCentimeters,
            weightKilograms: weightKilograms,
            activityLevel: activityLevel,
            goal: goal
        )

        self.id = id
        self.displayNameValue = displayName
        self.sex = sex
        self.age = age
        self.heightCentimeters = heightCentimeters
        self.weightKilograms = weightKilograms
        self.activityLevel = activityLevel
        self.goal = goal
        self.unitSystemRawValue = unitSystem.rawValue
        self.targetCaloriesValue = targetCalories ?? calculatedTargets.calories
        self.targetProteinValue = targetProtein ?? calculatedTargets.protein
        self.targetFatValue = targetFat ?? calculatedTargets.fat
        self.targetCarbsValue = targetCarbs ?? calculatedTargets.carbs
        self.createdAt = createdAt
    }
}

extension UserProfile {
    var displayName: String {
        get {
            let trimmedName = (displayNameValue ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedName.isEmpty ? "Bohdan" : trimmedName
        }
        set {
            displayNameValue = newValue
        }
    }

    var unitSystem: UnitSystem {
        get {
            UnitSystem(rawValue: unitSystemRawValue ?? "") ?? .metric
        }
        set {
            unitSystemRawValue = newValue.rawValue
        }
    }

    var targetCalories: Double {
        get { targetCaloriesValue ?? calculatedTargetsFromProfile.calories }
        set { targetCaloriesValue = newValue }
    }

    var targetProtein: Double {
        get { targetProteinValue ?? calculatedTargetsFromProfile.protein }
        set { targetProteinValue = newValue }
    }

    var targetFat: Double {
        get { targetFatValue ?? calculatedTargetsFromProfile.fat }
        set { targetFatValue = newValue }
    }

    var targetCarbs: Double {
        get { targetCarbsValue ?? calculatedTargetsFromProfile.carbs }
        set { targetCarbsValue = newValue }
    }

    var dailyTargets: MacroTargets {
        MacroTargets(
            calories: targetCalories,
            protein: targetProtein,
            fat: targetFat,
            carbs: targetCarbs
        )
    }

    var calculatedTargetsFromProfile: MacroTargets {
        Self.calculateTargets(
            sex: sex,
            age: age,
            heightCentimeters: heightCentimeters,
            weightKilograms: weightKilograms,
            activityLevel: activityLevel,
            goal: goal
        )
    }

    func applyCalculatedTargetsFromProfile() {
        let targets = calculatedTargetsFromProfile
        targetCalories = targets.calories
        targetProtein = targets.protein
        targetFat = targets.fat
        targetCarbs = targets.carbs
    }

    private static func calculateTargets(
        sex: Sex,
        age: Int,
        heightCentimeters: Double,
        weightKilograms: Double,
        activityLevel: ActivityLevel,
        goal: NutritionGoal
    ) -> MacroTargets {
        let sexOffset = sex == .male ? 5.0 : -161.0
        let basalMetabolicRate = 10 * weightKilograms + 6.25 * heightCentimeters - 5 * Double(age) + sexOffset
        let maintenanceCalories = basalMetabolicRate * activityLevel.multiplier
        let calories = max(1_200, maintenanceCalories * (1 + goal.calorieAdjustment))

        let proteinGrams = weightKilograms * proteinMultiplier(for: goal)
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

    private static func proteinMultiplier(for goal: NutritionGoal) -> Double {
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
