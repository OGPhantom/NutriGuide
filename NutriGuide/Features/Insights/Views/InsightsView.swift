import SwiftData
import SwiftUI

struct InsightsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealEntry.loggedAt, order: .reverse) private var meals: [MealEntry]
    @Query private var profiles: [UserProfile]
    @Query(sort: \CoachInsight.createdAt, order: .reverse) private var insights: [CoachInsight]

    @State private var viewModel: InsightsViewModel

    init(client: any CoachInsightGenerating = FoundationCoachInsightClient()) {
        _viewModel = State(initialValue: InsightsViewModel(client: client))
    }

    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }

    private var latestInsight: CoachInsight? {
        insights.first
    }

    var body: some View {
        let request = viewModel.request(from: meals, profile: profile)
        let averages = latestInsight?.macroAverages ?? MacroTargets(
            calories: request.averageCalories,
            protein: request.averageProtein,
            fat: request.averageFat,
            carbs: request.averageCarbs
        )

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                Text("Insights")
                    .font(NutriTypography.screenTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                InsightHeroCard(
                    insight: latestInsight,
                    request: request,
                    availability: viewModel.clientAvailability,
                    phase: viewModel.phase,
                    onGenerate: {
                        viewModel.startGeneration(
                            meals: meals,
                            profile: profile,
                            existingInsights: insights,
                            in: modelContext
                        )
                    }
                )

                MacroBalanceCard(averages: averages)

                RecommendationsCard(recommendations: latestInsight?.recommendations ?? [])
            }
            .padding(.horizontal, 20)
            .padding(.top, 26)
            .padding(.bottom, 110)
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            viewModel.seedDefaultProfileIfNeeded(in: modelContext)
        }
    }
}

#Preview("Generated") {
    NavigationStack {
        InsightsView(client: PreviewCoachInsightClient())
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: true, includeInsight: true))
}

#Preview("Needs More Data") {
    NavigationStack {
        InsightsView(client: PreviewCoachInsightClient())
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: false, includeInsight: false))
}

#Preview("Unavailable") {
    NavigationStack {
        InsightsView(client: PreviewCoachInsightClient(availability: .unavailable))
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: true, includeInsight: false))
}
