import Foundation
import SwiftData

enum PreviewFixtures {
    static var meals: [MealEntry] {
        [
            MealEntry(
                name: "Chicken quinoa bowl",
                calories: 520,
                protein: 38,
                fat: 18,
                carbs: 42,
                loggedAt: .now.addingTimeInterval(-60 * 45),
                mealType: .lunch,
                ingredients: [
                    MealIngredient(name: "Chicken", amount: 120, unit: "g", calories: 198),
                    MealIngredient(name: "Quinoa", amount: 90, unit: "g", calories: 111),
                    MealIngredient(name: "Avocado", amount: 50, unit: "g", calories: 80)
                ]
            ),
            MealEntry(
                name: "Greek yogurt with berries",
                calories: 280,
                protein: 24,
                fat: 7,
                carbs: 31,
                loggedAt: .now.addingTimeInterval(-60 * 60 * 4),
                mealType: .breakfast,
                ingredients: [
                    MealIngredient(name: "Greek yogurt", amount: 180, unit: "g", calories: 120),
                    MealIngredient(name: "Blueberries", amount: 70, unit: "g", calories: 40)
                ]
            ),
            MealEntry(
                name: "Salmon avocado plate",
                calories: 610,
                protein: 42,
                fat: 33,
                carbs: 35,
                loggedAt: .now.addingTimeInterval(-60 * 60 * 21),
                mealType: .dinner,
                ingredients: [
                    MealIngredient(name: "Salmon", amount: 150, unit: "g", calories: 310),
                    MealIngredient(name: "Avocado", amount: 80, unit: "g", calories: 128)
                ]
            )
        ]
    }

    static func previewContainer(includeMeals: Bool = true) -> ModelContainer {
        let schema = Schema([MealEntry.self, MealIngredient.self, UserProfile.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        container.mainContext.insert(UserProfile())

        if includeMeals {
            for meal in meals {
                container.mainContext.insert(meal)
            }
        }

        try? container.mainContext.save()
        return container
    }
}
