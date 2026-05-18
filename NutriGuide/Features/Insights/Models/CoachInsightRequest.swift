import Foundation

struct CoachInsightRequest: Sendable {
    var generatedAt: Date
    var periodStart: Date
    var periodEnd: Date
    var profile: Profile
    var targets: Targets
    var dayCount: Int
    var daysWithMeals: Int
    var mealCount: Int
    var averageCalories: Double
    var averageProtein: Double
    var averageFat: Double
    var averageCarbs: Double
    var days: [Day]
    var meals: [Meal]

    var isEligible: Bool {
        mealCount >= 3 && daysWithMeals >= 2
    }
}

extension CoachInsightRequest {
    struct Profile: Sendable {
        var displayName: String
        var sex: String
        var age: Int
        var heightCentimeters: Double
        var weightKilograms: Double
        var activityLevel: String
        var nutritionGoal: String
    }

    struct Targets: Sendable {
        var calories: Double
        var protein: Double
        var fat: Double
        var carbs: Double
    }

    struct Day: Identifiable, Sendable {
        var id: Date { date }
        var date: Date
        var calories: Double
        var protein: Double
        var fat: Double
        var carbs: Double
        var mealCount: Int
    }

    struct Meal: Identifiable, Sendable {
        var id: UUID
        var loggedAt: Date
        var mealType: String
        var name: String
        var calories: Double
        var protein: Double
        var fat: Double
        var carbs: Double
        var ingredients: [Ingredient]
    }

    struct Ingredient: Sendable {
        var name: String
        var amount: Double
        var unit: String
    }
}
