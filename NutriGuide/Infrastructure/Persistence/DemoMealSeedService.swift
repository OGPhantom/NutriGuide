import Foundation
import SwiftData

enum DemoMealSeedService {
    static func seedLast50Days(in modelContext: ModelContext, calendar: Calendar = .current) throws {
        let existingMeals = try modelContext.fetch(FetchDescriptor<MealEntry>())

        for meal in existingMeals {
            modelContext.delete(meal)
        }

        let today = calendar.startOfDay(for: .now)

        for dayOffset in 0..<50 {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: today) else {
                continue
            }

            for template in templates(for: dayOffset) {
                let meal = MealEntry(
                    name: template.name,
                    calories: adjusted(template.calories, dayOffset: dayOffset, index: template.index),
                    protein: adjusted(template.protein, dayOffset: dayOffset, index: template.index, spread: 4),
                    fat: adjusted(template.fat, dayOffset: dayOffset, index: template.index, spread: 3),
                    carbs: adjusted(template.carbs, dayOffset: dayOffset, index: template.index, spread: 7),
                    loggedAt: loggedAt(for: day, hour: template.hour, minute: template.minute, calendar: calendar),
                    mealType: template.mealType,
                    ingredients: template.ingredients.map {
                        MealIngredient(name: $0.name, amount: $0.amount, unit: $0.unit, calories: $0.calories)
                    }
                )

                modelContext.insert(meal)
            }
        }

        try modelContext.save()
    }

    private static func templates(for dayOffset: Int) -> [DemoMealTemplate] {
        var selectedTemplates: [DemoMealTemplate] = [
            breakfasts[dayOffset % breakfasts.count],
            lunches[(dayOffset + 2) % lunches.count],
            dinners[(dayOffset + 4) % dinners.count]
        ]

        if dayOffset % 3 != 1 {
            selectedTemplates.append(snacks[(dayOffset + 1) % snacks.count])
        }

        return selectedTemplates
    }

    private static func adjusted(_ value: Double, dayOffset: Int, index: Int, spread: Int = 45) -> Double {
        let delta = Double(((dayOffset + index * 7) % spread) - spread / 2)
        return max(1, (value + delta).rounded())
    }

    private static func loggedAt(for day: Date, hour: Int, minute: Int, calendar: Calendar) -> Date {
        calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
    }
}

private struct DemoMealTemplate {
    var index: Int
    var name: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var hour: Int
    var minute: Int
    var mealType: MealType
    var ingredients: [DemoIngredientTemplate]
}

private struct DemoIngredientTemplate {
    var name: String
    var amount: Double
    var unit: String
    var calories: Double
}

private extension DemoMealSeedService {
    static let breakfasts: [DemoMealTemplate] = [
        DemoMealTemplate(
            index: 1,
            name: "Greek yogurt with berries",
            calories: 315,
            protein: 28,
            fat: 8,
            carbs: 36,
            hour: 8,
            minute: 15,
            mealType: .breakfast,
            ingredients: [
                DemoIngredientTemplate(name: "Greek yogurt", amount: 190, unit: "g", calories: 124),
                DemoIngredientTemplate(name: "Blueberries", amount: 80, unit: "g", calories: 46),
                DemoIngredientTemplate(name: "Granola", amount: 30, unit: "g", calories: 135)
            ]
        ),
        DemoMealTemplate(
            index: 2,
            name: "Avocado toast with eggs",
            calories: 430,
            protein: 24,
            fat: 24,
            carbs: 34,
            hour: 8,
            minute: 35,
            mealType: .breakfast,
            ingredients: [
                DemoIngredientTemplate(name: "Sourdough bread", amount: 80, unit: "g", calories: 208),
                DemoIngredientTemplate(name: "Eggs", amount: 2, unit: "pcs", calories: 144),
                DemoIngredientTemplate(name: "Avocado", amount: 65, unit: "g", calories: 104)
            ]
        ),
        DemoMealTemplate(
            index: 3,
            name: "Oatmeal with banana",
            calories: 390,
            protein: 15,
            fat: 11,
            carbs: 63,
            hour: 7,
            minute: 55,
            mealType: .breakfast,
            ingredients: [
                DemoIngredientTemplate(name: "Oats", amount: 60, unit: "g", calories: 228),
                DemoIngredientTemplate(name: "Banana", amount: 110, unit: "g", calories: 98),
                DemoIngredientTemplate(name: "Almond butter", amount: 12, unit: "g", calories: 74)
            ]
        )
    ]

    static let lunches: [DemoMealTemplate] = [
        DemoMealTemplate(
            index: 4,
            name: "Chicken quinoa bowl",
            calories: 560,
            protein: 42,
            fat: 18,
            carbs: 58,
            hour: 12,
            minute: 40,
            mealType: .lunch,
            ingredients: [
                DemoIngredientTemplate(name: "Chicken breast", amount: 140, unit: "g", calories: 231),
                DemoIngredientTemplate(name: "Quinoa", amount: 110, unit: "g", calories: 132),
                DemoIngredientTemplate(name: "Avocado", amount: 55, unit: "g", calories: 88),
                DemoIngredientTemplate(name: "Spinach", amount: 35, unit: "g", calories: 8)
            ]
        ),
        DemoMealTemplate(
            index: 5,
            name: "Turkey rice plate",
            calories: 610,
            protein: 45,
            fat: 16,
            carbs: 72,
            hour: 13,
            minute: 5,
            mealType: .lunch,
            ingredients: [
                DemoIngredientTemplate(name: "Turkey", amount: 150, unit: "g", calories: 255),
                DemoIngredientTemplate(name: "Brown rice", amount: 160, unit: "g", calories: 178),
                DemoIngredientTemplate(name: "Cucumber", amount: 80, unit: "g", calories: 12)
            ]
        ),
        DemoMealTemplate(
            index: 6,
            name: "Lentil soup and salad",
            calories: 480,
            protein: 25,
            fat: 14,
            carbs: 62,
            hour: 12,
            minute: 20,
            mealType: .lunch,
            ingredients: [
                DemoIngredientTemplate(name: "Lentils", amount: 180, unit: "g", calories: 209),
                DemoIngredientTemplate(name: "Tomato", amount: 100, unit: "g", calories: 18),
                DemoIngredientTemplate(name: "Olive oil", amount: 10, unit: "g", calories: 90)
            ]
        )
    ]

    static let dinners: [DemoMealTemplate] = [
        DemoMealTemplate(
            index: 7,
            name: "Salmon with roasted vegetables",
            calories: 650,
            protein: 46,
            fat: 34,
            carbs: 39,
            hour: 19,
            minute: 25,
            mealType: .dinner,
            ingredients: [
                DemoIngredientTemplate(name: "Salmon", amount: 160, unit: "g", calories: 333),
                DemoIngredientTemplate(name: "Potatoes", amount: 130, unit: "g", calories: 113),
                DemoIngredientTemplate(name: "Broccoli", amount: 100, unit: "g", calories: 34)
            ]
        ),
        DemoMealTemplate(
            index: 8,
            name: "Tofu noodle stir fry",
            calories: 590,
            protein: 31,
            fat: 22,
            carbs: 68,
            hour: 18,
            minute: 55,
            mealType: .dinner,
            ingredients: [
                DemoIngredientTemplate(name: "Tofu", amount: 160, unit: "g", calories: 230),
                DemoIngredientTemplate(name: "Rice noodles", amount: 120, unit: "g", calories: 220),
                DemoIngredientTemplate(name: "Bell pepper", amount: 80, unit: "g", calories: 25)
            ]
        ),
        DemoMealTemplate(
            index: 9,
            name: "Beef sweet potato bowl",
            calories: 720,
            protein: 48,
            fat: 28,
            carbs: 66,
            hour: 19,
            minute: 40,
            mealType: .dinner,
            ingredients: [
                DemoIngredientTemplate(name: "Lean beef", amount: 150, unit: "g", calories: 326),
                DemoIngredientTemplate(name: "Sweet potato", amount: 180, unit: "g", calories: 162),
                DemoIngredientTemplate(name: "Arugula", amount: 40, unit: "g", calories: 10)
            ]
        )
    ]

    static let snacks: [DemoMealTemplate] = [
        DemoMealTemplate(
            index: 10,
            name: "Apple with almond butter",
            calories: 210,
            protein: 5,
            fat: 10,
            carbs: 28,
            hour: 16,
            minute: 20,
            mealType: .snacks,
            ingredients: [
                DemoIngredientTemplate(name: "Apple", amount: 150, unit: "g", calories: 78),
                DemoIngredientTemplate(name: "Almond butter", amount: 20, unit: "g", calories: 124)
            ]
        ),
        DemoMealTemplate(
            index: 11,
            name: "Protein smoothie",
            calories: 285,
            protein: 27,
            fat: 7,
            carbs: 31,
            hour: 15,
            minute: 45,
            mealType: .snacks,
            ingredients: [
                DemoIngredientTemplate(name: "Protein powder", amount: 30, unit: "g", calories: 120),
                DemoIngredientTemplate(name: "Milk", amount: 220, unit: "ml", calories: 103),
                DemoIngredientTemplate(name: "Strawberries", amount: 80, unit: "g", calories: 26)
            ]
        )
    ]
}
