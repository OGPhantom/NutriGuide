import SwiftData
import SwiftUI

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var viewModel = ProfileViewModel()

    var body: some View {
        Group {
            if let profile = profiles.first {
                profileContent(profile)
            } else {
                loadingState
            }
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            viewModel.seedDefaultProfileIfNeeded(in: modelContext)
        }
        .sheet(item: $viewModel.presentedSheet) { destination in
            if let profile = profiles.first {
                sheet(for: destination, profile: profile)
            }
        }
    }

    private func profileContent(_ profile: UserProfile) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                Text("Me")
                    .font(NutriTypography.screenTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                ProfileHeroCard(
                    profile: profile,
                    action: viewModel.showIdentityEditor
                )

                BodyProfileCard(
                    profile: profile,
                    action: viewModel.showBodyProfileEditor
                )

                ActivityGoalCard(
                    profile: profile,
                    action: viewModel.showActivityGoalEditor
                )

                DailyTargetsProfileCard(
                    profile: profile,
                    action: viewModel.showDailyTargetsEditor
                )

                ProfileSettingsCard(profile: profile)
            }
            .padding(.horizontal, 20)
            .padding(.top, 26)
            .padding(.bottom, 110)
        }
    }

    private var loadingState: some View {
        VStack {
            ProgressView()
                .tint(NutriColors.olive)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func sheet(for destination: ProfileSheetDestination, profile: UserProfile) -> some View {
        switch destination {
        case .identity:
            EditIdentitySheet(profile: profile)
        case .bodyProfile:
            EditBodyProfileSheet(profile: profile)
        case .activityGoal:
            EditActivityGoalSheet(profile: profile)
        case .dailyTargets:
            EditDailyTargetsSheet(profile: profile)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
