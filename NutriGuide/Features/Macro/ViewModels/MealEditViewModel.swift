import Foundation
import SwiftData

@MainActor
@Observable
final class MealEditViewModel {
    var name: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var mealType: MealType
    var ingredients: [IngredientDraft]

    init(meal: MealEntry) {
        name = meal.name
        calories = meal.calories
        protein = meal.protein
        fat = meal.fat
        carbs = meal.carbs
        mealType = meal.mealType
        ingredients = meal.ingredients.map {
            IngredientDraft(id: $0.id, name: $0.name, amount: $0.amount, unit: $0.unit, calories: $0.calories)
        }
    }

    func save(meal: MealEntry, in modelContext: ModelContext) {
        meal.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        meal.calories = calories
        meal.protein = protein
        meal.fat = fat
        meal.carbs = carbs
        meal.mealType = mealType

        for ingredient in meal.ingredients {
            modelContext.delete(ingredient)
        }

        meal.ingredients = ingredients.map {
            MealIngredient(name: $0.name, amount: $0.amount, unit: $0.unit, calories: $0.calories, meal: meal)
        }

        try? modelContext.save()
    }
}
