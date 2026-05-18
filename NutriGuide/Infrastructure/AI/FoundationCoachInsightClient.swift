import Foundation
import FoundationModels

struct FoundationCoachInsightClient: CoachInsightGenerating {
    var availability: CoachInsightClientAvailability {
        switch SystemLanguageModel.default.availability {
        case .available:
            .available
        case .unavailable:
            .unavailable
        }
    }

    func generateInsight(for request: CoachInsightRequest) async throws -> CoachInsightGeneratedContent {
        guard availability == .available else {
            throw FoundationCoachInsightError.unavailable
        }

        let session = LanguageModelSession(instructions: instructions)
        let response = try await session.respond(
            to: prompt(for: request),
            generating: FoundationCoachInsightOutput.self,
            includeSchemaInPrompt: true,
            options: GenerationOptions(sampling: .greedy, temperature: 0.2)
        )

        return response.content.domainContent
    }

    private var instructions: String {
        """
        You are NutriGuide's premium wellness nutrition coach. Generate a concise, helpful AI Coach Summary from the supplied logged meals and profile data only. Do not diagnose medical conditions, do not make claims that require clinical certainty, and do not invent missing meals or ingredients. Keep the tone calm, editorial, and direct.
        """
    }

    private func prompt(for request: CoachInsightRequest) -> String {
        """
        Generate an AI Coach Summary for the last 7 calendar days.

        Rules:
        - Use only the data below.
        - Tie the headline to the strongest detected pattern in calories or macro balance.
        - Headline format must be 5 to 8 words, soft and editorial, no colon, no exclamation, no alert wording.
        - Good headline examples: "Your week is leaning light on protein", "Your meals are trending carb heavy", "Your week looks steady and balanced".
        - Bad headline examples: "Calorie surplus alert: Reduce intake to lose weight", "Protein Deficit: Increase Your Intake".
        - Compare macros against the user's targets and macro calorie distribution. Do not assume carbs are high only because carb grams are numerically higher than protein or fat grams.
        - Mention limited data gently if daysWithMeals is low.
        - Return exactly 3 recommendations.
        - Each recommendation must be food-level and practical: what to add, swap, or pair.
        - Do not write generic advice like "reduce carb intake", "increase protein intake", or "increase fiber intake" unless you name a concrete food or meal.
        - Do not reference day numbers, dates, "days 10, 11", or numbered days in recommendations.
        - Do not repeat the same idea twice with different wording.
        - Keep recommendation titles 3 to 6 words.
        - Keep recommendation bodies under 18 words.
        - Choose recommendation symbolName from: leaf, drop, fork.knife, carrot, figure.walk, target.

        User profile:
        \(profilePayload(request.profile))

        Daily targets:
        calories \(request.targets.calories.nutriRounded), protein \(request.targets.protein.nutriRounded) g, fat \(request.targets.fat.nutriRounded) g, carbs \(request.targets.carbs.nutriRounded) g

        Period:
        start \(request.periodStart.nutriPromptDate), end \(request.periodEnd.nutriPromptDate), calendarDays \(request.dayCount), daysWithMeals \(request.daysWithMeals), mealCount \(request.mealCount)

        Seven-day daily averages:
        calories \(request.averageCalories.nutriRounded), protein \(request.averageProtein.nutriRounded) g, fat \(request.averageFat.nutriRounded) g, carbs \(request.averageCarbs.nutriRounded) g

        Daily breakdown:
        \(dailyBreakdownPayload(request.days))

        Meals:
        \(mealsPayload(request.meals))
        """
    }

    private func profilePayload(_ profile: CoachInsightRequest.Profile) -> String {
        """
        name \(profile.displayName), sex \(profile.sex), age \(profile.age), height \(profile.heightCentimeters.nutriRounded) cm, weight \(profile.weightKilograms.nutriRounded) kg, activity \(profile.activityLevel), goal \(profile.nutritionGoal)
        """
    }

    private func dailyBreakdownPayload(_ days: [CoachInsightRequest.Day]) -> String {
        days.map { day in
            "- \(day.date.nutriPromptDate): meals \(day.mealCount), calories \(day.calories.nutriRounded), protein \(day.protein.nutriRounded) g, fat \(day.fat.nutriRounded) g, carbs \(day.carbs.nutriRounded) g"
        }
        .joined(separator: "\n")
    }

    private func mealsPayload(_ meals: [CoachInsightRequest.Meal]) -> String {
        guard !meals.isEmpty else {
            return "- none"
        }

        return meals.map { meal in
            let ingredients = meal.ingredients.isEmpty
                ? "ingredients: none"
                : "ingredients: " + meal.ingredients.map { "\($0.name) \($0.amount.nutriRounded) \($0.unit)" }.joined(separator: ", ")

            return "- \(meal.loggedAt.nutriPromptDateTime), \(meal.mealType), \(meal.name): \(meal.calories.nutriRounded) kcal, protein \(meal.protein.nutriRounded) g, fat \(meal.fat.nutriRounded) g, carbs \(meal.carbs.nutriRounded) g; \(ingredients)"
        }
        .joined(separator: "\n")
    }
}

private extension FoundationCoachInsightOutput {
    nonisolated var domainContent: CoachInsightGeneratedContent {
        CoachInsightGeneratedContent(
            headline: headline.cleanedInsightText,
            summary: summary.cleanedInsightText,
            recommendations: recommendations.prefix(3).map(\.domainRecommendation)
        )
    }
}

private extension FoundationCoachRecommendationOutput {
    nonisolated var domainRecommendation: CoachRecommendation {
        CoachRecommendation(
            title: title.cleanedInsightText,
            body: body.cleanedInsightText,
            symbolName: symbolName.allowedInsightSymbolName
        )
    }
}

private extension String {
    nonisolated var cleanedInsightText: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    nonisolated var allowedInsightSymbolName: String {
        let allowedSymbols = Set(["leaf", "drop", "fork.knife", "carrot", "figure.walk", "target"])
        let trimmed = cleanedInsightText
        return allowedSymbols.contains(trimmed) ? trimmed : "leaf"
    }

}

private extension Date {
    var nutriPromptDate: String {
        formatted(.iso8601.year().month().day())
    }

    var nutriPromptDateTime: String {
        formatted(.iso8601.year().month().day().time(includingFractionalSeconds: false))
    }
}

private extension Double {
    var nutriRounded: String {
        formatted(.number.precision(.fractionLength(0)))
    }
}

enum FoundationCoachInsightError: Error {
    case unavailable
}
