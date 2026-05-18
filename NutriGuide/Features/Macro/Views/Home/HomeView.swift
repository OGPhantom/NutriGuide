import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealEntry.loggedAt, order: .reverse) private var meals: [MealEntry]
    @Query private var profiles: [UserProfile]

    @State private var viewModel = HomeViewModel()

    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }

    private var todaysMeals: [MealEntry] {
        meals.filter { Calendar.current.isDateInToday($0.loggedAt) }
    }

    private var isFlowPresented: Binding<Bool> {
        Binding(
            get: { viewModel.isFlowPresented },
            set: { isPresented in
                viewModel.setFlowPresented(isPresented)
            }
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    greeting

                    hero

                    DailySummaryCard(meals: todaysMeals, targets: profile.dailyTargets)

                    RecentMealsCard(
                        meals: Array(meals.prefix(3)),
                        onSelectMeal: { meal in
                            viewModel.showDetail(for: meal)
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 26)
                .padding(.bottom, 110)
            }
            .background(NutriColors.cream.ignoresSafeArea())

            if let toast = viewModel.toast {
                NutriToastView(toast: toast)
                    .padding(.bottom, 74)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        .task {
            viewModel.seedDefaultProfileIfNeeded(in: modelContext)
        }
        .fullScreenCover(isPresented: isFlowPresented) {
            if let presentedFlow = viewModel.presentedFlow {
                flowDestinationView(presentedFlow)
            }
        }
    }

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.greetingText())
                .font(.system(.title3, design: .serif).weight(.regular))
                .foregroundStyle(NutriColors.text)

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(profile.displayName)
                    .font(.system(size: 54, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.oliveDark)
                    .minimumScaleFactor(0.78)
                    .lineLimit(1)

                Image(systemName: "laurel.trailing")
                    .font(.system(size: 48, weight: .light, design: .serif))
                    .foregroundStyle(NutriColors.apricot.opacity(0.72))
                    .rotationEffect(.degrees(-26))
                    .offset(y: -2)
                    .accessibilityHidden(true)
            }
        }
    }

    private var hero: some View {
        Button(action: viewModel.openCamera) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(NutriColors.surface)
                        .frame(width: 66, height: 66)
                        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 7)

                    Image(systemName: "camera")
                        .font(.system(.title2, design: .rounded).weight(.medium))
                        .foregroundStyle(NutriColors.olive)
                }
                .offset(x: -60)

                ZStack{
                    Text("Scan\nyour meal")
                        .font(NutriTypography.heroTitle)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .offset(x: -60)

                    Spacer(minLength: 0)

                    PremiumFoodRenderView()
                        .offset(x: 90, y: 30)
                }
            }
            .padding(.leading, 18)
            .padding(.vertical, 18)
            .padding(.trailing, 0)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(
                LinearGradient(
                    colors: [NutriColors.olive, NutriColors.oliveDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: NutriColors.oliveDark.opacity(0.18), radius: 18, x: 0, y: 12)
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Scan your meal")
    }

    @ViewBuilder
    private func flowDestinationView(_ destination: MealFlowDestination) -> some View {
        switch destination {
        case .camera:
            CameraView(
                onClose: {
                    viewModel.closeFlow()
                },
                onPhotoCaptured: { data in
                    viewModel.handleCapturedPhoto(data)
                }
            )
        case .analyzing(let photo):
            AnalyzingView(
                photo: photo,
                onGoHome: {
                    viewModel.closeFlow()
                },
                onAnalysisComplete: { analysis in
                    viewModel.handleAnalysisComplete(analysis, photo: photo)
                }
            )
        case .review(let photo, let analysis):
            ReviewMealView(
                photo: photo,
                initialDraft: viewModel.reviewDraft(for: analysis),
                onDiscard: {
                    viewModel.closeFlow()
                },
                onRetakePhoto: {
                    viewModel.retakePhoto()
                },
                onSave: { draft in
                    viewModel.saveReviewedMeal(draft, in: modelContext)
                }
            )
        case .detail(let meal):
            MealDetailSheet(meal: meal)
        }
    }
}

#Preview("Loaded") {
    NavigationStack {
        HomeView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}

#Preview("Empty") {
    NavigationStack {
        HomeView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
