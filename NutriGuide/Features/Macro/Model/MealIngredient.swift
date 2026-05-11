import Foundation
import SwiftData

@Model
final class MealIngredient {
    var id: UUID
    var name: String
    var amount: Double
    var unit: String
    var calories: Double
    var meal: MealEntry?

    init(
        id: UUID = UUID(),
        name: String,
        amount: Double,
        unit: String,
        calories: Double = 0,
        meal: MealEntry? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
        self.calories = calories
        self.meal = meal
    }
}
