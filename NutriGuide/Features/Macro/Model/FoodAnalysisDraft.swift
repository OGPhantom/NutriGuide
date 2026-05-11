import Foundation

struct FoodAnalysisDraft: Equatable {
    var name: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var ingredients: [IngredientDraft]
}

struct IngredientDraft: Identifiable, Equatable {
    var id: UUID
    var name: String
    var amount: Double
    var unit: String
    var calories: Double

    init(
        id: UUID = UUID(),
        name: String,
        amount: Double,
        unit: String,
        calories: Double = 0
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
        self.calories = calories
    }
}

extension FoodAnalysisDraft {
    static let preview = FoodAnalysisDraft(
        name: "Chicken quinoa bowl",
        calories: 520,
        protein: 38,
        fat: 18,
        carbs: 42,
        ingredients: [
            IngredientDraft(name: "Chicken", amount: 120, unit: "g", calories: 198),
            IngredientDraft(name: "Quinoa", amount: 90, unit: "g", calories: 111),
            IngredientDraft(name: "Avocado", amount: 50, unit: "g", calories: 80),
            IngredientDraft(name: "Spinach", amount: 35, unit: "g", calories: 8)
        ]
    )
}
