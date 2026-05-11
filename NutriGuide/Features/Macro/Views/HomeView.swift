import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealEntry.loggedAt, order: .reverse) private var meals: [MealEntry]
    @Query private var profiles: [UserProfile]

    @State private var presentedFlow: MealFlowDestination?
    @State private var toast: NutriToast?

    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }

    private var todaysMeals: [MealEntry] {
        meals.filter { Calendar.current.isDateInToday($0.loggedAt) }
    }

    private var isFlowPresented: Binding<Bool> {
        Binding(
            get: { presentedFlow != nil },
            set: { isPresented in
                if !isPresented {
                    presentedFlow = nil
                }
            }
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    greeting

                    ScanHeroCard {
                        presentedFlow = .camera
                    }

                    DailySummaryCard(meals: todaysMeals, targets: profile.dailyTargets)

                    RecentMealsCard(
                        meals: Array(meals.prefix(3)),
                        onSelectMeal: { meal in
                            presentedFlow = .detail(meal)
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 26)
                .padding(.bottom, 110)
            }
            .background(NutriColors.cream.ignoresSafeArea())

            if let toast {
                NutriToastView(toast: toast)
                    .padding(.bottom, 74)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        .task {
            try? ProfileSeedService.seedDefaultProfileIfNeeded(in: modelContext)
        }
        .fullScreenCover(isPresented: isFlowPresented) {
            if let presentedFlow {
                flowDestinationView(presentedFlow)
            }
        }
    }

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Good morning,")
                .font(.system(.title2, design: .serif))
                .foregroundStyle(NutriColors.text)

            Text("Nikita")
                .font(.system(.largeTitle, design: .serif).weight(.regular))
                .foregroundStyle(NutriColors.oliveDark)

            Text("Let's nourish your best self.")
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    @ViewBuilder
    private func flowDestinationView(_ destination: MealFlowDestination) -> some View {
        switch destination {
        case .camera:
            CameraView(
                onClose: { presentedFlow = nil },
                onPhotoCaptured: { data in
                    presentedFlow = .analyzing(CapturedMealPhoto(data: data))
                }
            )
        case .analyzing(let photo):
            AnalyzingView(
                photo: photo,
                client: OpenAIFoodAnalysisClient(),
                onGoHome: { presentedFlow = nil },
                onAnalysisComplete: { analysis in
                    presentedFlow = .review(photo, analysis)
                }
            )
        case .review(let photo, let analysis):
            ReviewMealView(
                photo: photo,
                initialDraft: ReviewMealDraft(
                    analysis: analysis,
                    mealType: MealType.suggested(for: .now),
                    loggedAt: .now
                ),
                onDiscard: { presentedFlow = nil },
                onRetakePhoto: { presentedFlow = .camera },
                onSave: saveReviewedMeal
            )
        case .detail(let meal):
            MealDetailSheet(meal: meal)
        }
    }

    private func saveReviewedMeal(_ draft: ReviewMealDraft) {
        let ingredients = draft.ingredients.map {
            MealIngredient(name: $0.name, amount: $0.amount, unit: $0.unit, calories: $0.calories)
        }

        let meal = MealEntry(
            name: draft.name,
            calories: draft.calories,
            protein: draft.protein,
            fat: draft.fat,
            carbs: draft.carbs,
            loggedAt: draft.loggedAt,
            mealType: draft.mealType,
            ingredients: ingredients
        )

        modelContext.insert(meal)
        try? modelContext.save()

        presentedFlow = nil
        showMealSavedToast()
    }

    private func showMealSavedToast() {
        withAnimation(.smooth(duration: 0.24)) {
            toast = NutriToast(message: "Meal saved", systemImage: "checkmark.circle.fill")
        }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))

            withAnimation(.smooth(duration: 0.24)) {
                toast = nil
            }
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
