import SwiftData
import SwiftUI

struct AllMealsView: View {
    @Query(sort: \MealEntry.loggedAt, order: .reverse) private var meals: [MealEntry]
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedFilter: MealTypeFilter = .all
    @State private var selectedMeal: MealEntry?

    private var filteredMeals: [MealEntry] {
        meals.filter { meal in
            filterMatches(meal) && searchMatches(meal)
        }
    }

    private var sections: [(Date, [MealEntry])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredMeals) { meal in
            calendar.startOfDay(for: meal.loggedAt)
        }

        return grouped
            .map { ($0.key, $0.value.sorted { $0.loggedAt > $1.loggedAt }) }
            .sorted { $0.0 > $1.0 }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                header
                searchField
                filters

                if sections.isEmpty {
                    emptyState
                } else {
                    VStack(alignment: .leading, spacing: 26) {
                        ForEach(sections, id: \.0) { day, meals in
                            AllMealsDaySection(
                                day: day,
                                meals: meals,
                                onSelectMeal: { selectedMeal = $0 }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 48)
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .navigationBarHidden(true)
        .fullScreenCover(item: $selectedMeal, content: MealDetailSheet.init)
    }

    private var header: some View {
        VStack(spacing: 10) {
            HStack {
                NutriIconButton(
                    title: "Back",
                    systemImage: "chevron.left",
                    size: 42,
                    foreground: NutriColors.oliveDark,
                    background: NutriColors.surface,
                    action: { dismiss() }
                )

                Spacer()
            }

            Text("All meals")
                .font(NutriTypography.screenTitle)
                .foregroundStyle(NutriColors.text)
                .frame(maxWidth: .infinity)

            Text("Recent nutrition history")
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(NutriColors.textMuted)

            TextField("Search meals or ingredients", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.text)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(NutriColors.surface)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(NutriColors.divider, lineWidth: 1))
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MealTypeFilter.allCases) { filter in
                    NutriFilterChip(
                        title: filter.title,
                        isSelected: selectedFilter == filter,
                        action: { selectedFilter = filter }
                    )
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No meals found")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            Text("Try another search term or meal type.")
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nutriSurfaceCard()
    }

    private func filterMatches(_ meal: MealEntry) -> Bool {
        switch selectedFilter {
        case .all:
            true
        case .type(let mealType):
            meal.mealType == mealType
        }
    }

    private func searchMatches(_ meal: MealEntry) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        if meal.name.localizedStandardContains(query) {
            return true
        }

        return meal.ingredients.contains { ingredient in
            ingredient.name.localizedStandardContains(query)
        }
    }
}

#Preview {
    NavigationStack {
        AllMealsView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}
