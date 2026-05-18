import SwiftData
import SwiftUI

struct AllMealsView: View {
    @Query(sort: \MealEntry.loggedAt, order: .reverse) private var meals: [MealEntry]
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = AllMealsViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        let sections = viewModel.sections(from: meals)

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                header
                searchField(searchText: $viewModel.searchText)
                filters(selectedFilter: $viewModel.selectedFilter)

                if sections.isEmpty {
                    emptyState
                } else {
                    VStack(alignment: .leading, spacing: 26) {
                        ForEach(sections, id: \.0) { day, meals in
                            AllMealsDaySection(
                                day: day,
                                meals: meals,
                                onSelectMeal: viewModel.selectMeal
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
        .fullScreenCover(item: $viewModel.selectedMeal, content: MealDetailSheet.init)
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

    private func searchField(searchText: Binding<String>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(NutriColors.textMuted)

            TextField("Search meals or ingredients", text: searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.text)
                .colorScheme(.light)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(NutriColors.surface)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(NutriColors.divider, lineWidth: 1))
    }

    private func filters(selectedFilter: Binding<MealTypeFilter>) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(MealTypeFilter.allCases) { filter in
                    NutriFilterChip(
                        title: filter.title,
                        isSelected: selectedFilter.wrappedValue == filter,
                        action: { selectedFilter.wrappedValue = filter }
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
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

}

#Preview {
    NavigationStack {
        AllMealsView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}
