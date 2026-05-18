import SwiftData
import SwiftUI

struct DiaryView: View {
    @Query(sort: \MealEntry.loggedAt, order: .reverse) private var meals: [MealEntry]
    @Query private var profiles: [UserProfile]

    @State private var viewModel = DiaryViewModel()

    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }

    private var selectedDayMeals: [MealEntry] {
        viewModel.mealsForSelectedDay(from: meals)
    }

    var body: some View {
        let selectedMeals = selectedDayMeals

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                Text("Diary")
                    .font(NutriTypography.screenTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                DiaryCalendarCard(
                    monthTitle: viewModel.monthTitle,
                    days: viewModel.calendarDays(from: meals),
                    onPreviousMonth: viewModel.showPreviousMonth,
                    onNextMonth: viewModel.showNextMonth,
                    onSelectDay: viewModel.selectDay
                )

                Text(viewModel.selectedDateTitle)
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.text)
                    .padding(.leading, 4)

                DiarySummaryCard(meals: selectedMeals, targets: profile.dailyTargets)

                if selectedMeals.isEmpty {
                    DiaryEmptyStateView()
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(selectedMeals.enumerated()), id: \.element.id) { index, meal in
                            RecentMealTimelineRow(
                                meal: meal,
                                isLast: index == selectedMeals.count - 1,
                                showsDateForNonToday: false,
                                onSelect: { viewModel.selectMeal(meal) }
                            )
                        }
                    }
                    .nutriSurfaceCard()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 26)
            .padding(.bottom, 110)
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .navigationBarHidden(true)
        .fullScreenCover(item: $viewModel.selectedMeal, content: MealDetailSheet.init)
    }
}

#Preview("Loaded") {
    NavigationStack {
        DiaryView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}

#Preview("Empty") {
    NavigationStack {
        DiaryView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
