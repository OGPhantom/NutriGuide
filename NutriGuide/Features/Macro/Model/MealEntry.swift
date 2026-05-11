import Foundation
import SwiftData

@Model
final class MealEntry: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var loggedAt: Date
    var mealType: MealType
    @Relationship(deleteRule: .cascade, inverse: \MealIngredient.meal) var ingredients: [MealIngredient]

    init(
        id: UUID = UUID(),
        name: String,
        calories: Double,
        protein: Double,
        fat: Double,
        carbs: Double,
        loggedAt: Date = .now,
        mealType: MealType,
        ingredients: [MealIngredient] = []
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.loggedAt = loggedAt
        self.mealType = mealType
        self.ingredients = ingredients

        for ingredient in ingredients {
            ingredient.meal = self
        }
    }
}

extension MealEntry {
    var macros: MacroTargets {
        MacroTargets(calories: calories, protein: protein, fat: fat, carbs: carbs)
    }
}
