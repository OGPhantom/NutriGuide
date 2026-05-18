import Foundation

struct ReviewMealDraft: Identifiable, Equatable {
    let id: UUID
    var name: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var ingredients: [IngredientDraft]
    var mealType: MealType
    var loggedAt: Date

    init(
        id: UUID = UUID(),
        analysis: FoodAnalysisDraft,
        mealType: MealType,
        loggedAt: Date = .now
    ) {
        self.id = id
        name = analysis.name
        calories = analysis.calories
        protein = analysis.protein
        fat = analysis.fat
        carbs = analysis.carbs
        ingredients = analysis.ingredients
        self.mealType = mealType
        self.loggedAt = loggedAt
    }

    var analysis: FoodAnalysisDraft {
        FoodAnalysisDraft(
            name: name,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            ingredients: ingredients
        )
    }
}

extension ReviewMealDraft {
    static let preview = ReviewMealDraft(
        analysis: .preview,
        mealType: .lunch,
        loggedAt: .now
    )
}
