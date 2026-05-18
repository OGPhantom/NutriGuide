import Foundation
import SwiftData

@MainActor
@Observable
final class InsightsViewModel {
    var phase: InsightsGenerationPhase = .idle

    private let client: any CoachInsightGenerating
    private let calendar: Calendar
    private var generationTask: Task<Void, Never>?

    init(
        client: any CoachInsightGenerating = FoundationCoachInsightClient(),
        calendar: Calendar = .current
    ) {
        self.client = client
        self.calendar = calendar
    }

    var clientAvailability: CoachInsightClientAvailability {
        client.availability
    }

    func seedDefaultProfileIfNeeded(in modelContext: ModelContext) {
        try? ProfileSeedService.seedDefaultProfileIfNeeded(in: modelContext)
    }

    func startGeneration(
        meals: [MealEntry],
        profile: UserProfile,
        existingInsights: [CoachInsight],
        in modelContext: ModelContext
    ) {
        generationTask?.cancel()
        generationTask = Task { @MainActor in
            await generateInsight(
                meals: meals,
                profile: profile,
                existingInsights: existingInsights,
                in: modelContext
            )
        }
    }

    func request(from meals: [MealEntry], profile: UserProfile, today: Date = .now) -> CoachInsightRequest {
        let periodEndDay = calendar.startOfDay(for: today)
        let periodStart = calendar.date(byAdding: .day, value: -6, to: periodEndDay) ?? periodEndDay
        let periodEndExclusive = calendar.date(byAdding: .day, value: 1, to: periodEndDay) ?? today

        let periodMeals = meals
            .filter { $0.loggedAt >= periodStart && $0.loggedAt < periodEndExclusive }
            .sorted { $0.loggedAt < $1.loggedAt }

        let days = (0..<7).compactMap { offset -> CoachInsightRequest.Day? in
            guard let day = calendar.date(byAdding: .day, value: offset, to: periodStart) else {
                return nil
            }

            let mealsForDay = periodMeals.filter { calendar.isDate($0.loggedAt, inSameDayAs: day) }
            let totals = macroTotals(for: mealsForDay)

            return CoachInsightRequest.Day(
                date: day,
                calories: totals.calories,
                protein: totals.protein,
                fat: totals.fat,
                carbs: totals.carbs,
                mealCount: mealsForDay.count
            )
        }

        let totals = macroTotals(for: periodMeals)
        let dayCount = max(days.count, 1)
        let targets = profile.dailyTargets

        return CoachInsightRequest(
            generatedAt: today,
            periodStart: periodStart,
            periodEnd: periodEndDay,
            profile: CoachInsightRequest.Profile(
                displayName: profile.displayName,
                sex: profile.sex.title,
                age: profile.age,
                heightCentimeters: profile.heightCentimeters,
                weightKilograms: profile.weightKilograms,
                activityLevel: profile.activityLevel.title,
                nutritionGoal: profile.goal.title
            ),
            targets: CoachInsightRequest.Targets(
                calories: targets.calories,
                protein: targets.protein,
                fat: targets.fat,
                carbs: targets.carbs
            ),
            dayCount: dayCount,
            daysWithMeals: days.filter { $0.mealCount > 0 }.count,
            mealCount: periodMeals.count,
            averageCalories: totals.calories / Double(dayCount),
            averageProtein: totals.protein / Double(dayCount),
            averageFat: totals.fat / Double(dayCount),
            averageCarbs: totals.carbs / Double(dayCount),
            days: days,
            meals: periodMeals.map { meal in
                CoachInsightRequest.Meal(
                    id: meal.id,
                    loggedAt: meal.loggedAt,
                    mealType: meal.mealType.title,
                    name: meal.name,
                    calories: meal.calories,
                    protein: meal.protein,
                    fat: meal.fat,
                    carbs: meal.carbs,
                    ingredients: meal.ingredients.map {
                        CoachInsightRequest.Ingredient(
                            name: $0.name,
                            amount: $0.amount,
                            unit: $0.unit
                        )
                    }
                )
            }
        )
    }

    func generateInsight(
        meals: [MealEntry],
        profile: UserProfile,
        existingInsights: [CoachInsight],
        in modelContext: ModelContext
    ) async {
        let request = request(from: meals, profile: profile)

        guard request.isEligible else {
            phase = .idle
            return
        }

        guard client.availability == .available else {
            phase = .idle
            return
        }

        phase = .generating

        do {
            let generatedContent = try await client.generateInsight(for: request)
            try Task.checkCancellation()
            save(generatedContent, request: request, existingInsights: existingInsights, in: modelContext)
            phase = .idle
        } catch is CancellationError {
            phase = .idle
        } catch {
            phase = .failed("We couldn’t generate your insight right now")
        }
    }

    func clearError() {
        if case .failed = phase {
            phase = .idle
        }
    }

    private func save(
        _ generatedContent: CoachInsightGeneratedContent,
        request: CoachInsightRequest,
        existingInsights: [CoachInsight],
        in modelContext: ModelContext
    ) {
        if let latest = existingInsights.first(where: { $0.id == CoachInsight.latestID }) {
            latest.update(with: generatedContent, request: request)
        } else {
            modelContext.insert(
                CoachInsight(
                    periodStart: request.periodStart,
                    periodEnd: request.periodEnd,
                    headline: generatedContent.headline,
                    summary: generatedContent.summary,
                    averageProtein: request.averageProtein,
                    averageFat: request.averageFat,
                    averageCarbs: request.averageCarbs,
                    recommendations: Array(generatedContent.recommendations.prefix(3))
                )
            )
        }

        for staleInsight in existingInsights where staleInsight.id != CoachInsight.latestID {
            modelContext.delete(staleInsight)
        }

        try? modelContext.save()
    }

    private func macroTotals(for meals: [MealEntry]) -> MacroTargets {
        meals.reduce(MacroTargets(calories: 0, protein: 0, fat: 0, carbs: 0)) { partial, meal in
            MacroTargets(
                calories: partial.calories + meal.calories,
                protein: partial.protein + meal.protein,
                fat: partial.fat + meal.fat,
                carbs: partial.carbs + meal.carbs
            )
        }
    }
}
