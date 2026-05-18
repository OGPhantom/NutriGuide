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

    static var coachRecommendations: [CoachRecommendation] {
        [
            CoachRecommendation(
                title: "Add protein earlier",
                body: "Bring a clear protein source into breakfast or lunch to support fullness.",
                symbolName: "leaf"
            ),
            CoachRecommendation(
                title: "Balance carb-heavy meals",
                body: "Pair grains or fruit with yogurt, eggs, fish, or legumes.",
                symbolName: "fork.knife"
            ),
            CoachRecommendation(
                title: "Keep hydration steady",
                body: "Aim for small glasses of water across the day instead of catching up at night.",
                symbolName: "drop"
            )
        ]
    }

    static var coachInsight: CoachInsight {
        CoachInsight(
            periodStart: Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: .now)) ?? .now,
            periodEnd: Calendar.current.startOfDay(for: .now),
            headline: "Your week is leaning light on protein",
            summary: "Your meals show a steady calorie rhythm, but protein is doing most of its work later in the day. A little more protein earlier can support energy and fullness.",
            averageProtein: 72,
            averageFat: 58,
            averageCarbs: 186,
            recommendations: coachRecommendations
        )
    }

    static func insightRequest(isEligible: Bool) -> CoachInsightRequest {
        let today = Calendar.current.startOfDay(for: .now)
        let start = Calendar.current.date(byAdding: .day, value: -6, to: today) ?? today

        return CoachInsightRequest(
            generatedAt: .now,
            periodStart: start,
            periodEnd: today,
            profile: CoachInsightRequest.Profile(
                displayName: "Bohdan",
                sex: "Male",
                age: 25,
                heightCentimeters: 180,
                weightKilograms: 80,
                activityLevel: "Lightly active",
                nutritionGoal: "Maintain weight"
            ),
            targets: CoachInsightRequest.Targets(calories: 2_482, protein: 128, fat: 69, carbs: 337),
            dayCount: 7,
            daysWithMeals: isEligible ? 2 : 1,
            mealCount: isEligible ? 3 : 1,
            averageCalories: isEligible ? 1_240 : 280,
            averageProtein: isEligible ? 72 : 14,
            averageFat: isEligible ? 58 : 8,
            averageCarbs: isEligible ? 186 : 30,
            days: [],
            meals: []
        )
    }

    static func previewContainer(includeMeals: Bool = true, includeInsight: Bool = false) -> ModelContainer {
        let schema = Schema([MealEntry.self, MealIngredient.self, UserProfile.self, CoachInsight.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        container.mainContext.insert(UserProfile())

        if includeMeals {
            for meal in meals {
                container.mainContext.insert(meal)
            }
        }

        if includeInsight {
            container.mainContext.insert(coachInsight)
        }

        try? container.mainContext.save()
        return container
    }
}
