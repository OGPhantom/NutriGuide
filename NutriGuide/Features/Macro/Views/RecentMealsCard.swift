import SwiftUI

struct RecentMealsCard: View {
    let meals: [MealEntry]
    let onSelectMeal: (MealEntry) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                Text("Recent")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.text)

                Spacer()

                NavigationLink {
                    AllMealsView()
                } label: {
                    Text("See all")
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(NutriColors.olive)
                }
            }

            if meals.isEmpty {
                EmptyRecentView()
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(meals.enumerated()), id: \.element.id) { index, meal in
                        RecentMealTimelineRow(
                            meal: meal,
                            isLast: index == meals.count - 1,
                            onSelect: { onSelectMeal(meal) }
                        )
                    }
                }
            }
        }
        .nutriSurfaceCard()
    }
}

#Preview("Loaded") {
    NavigationStack {
        RecentMealsCard(meals: PreviewFixtures.meals) { _ in }
            .padding()
            .background(NutriColors.cream)
    }
}

#Preview("Empty") {
    NavigationStack {
        RecentMealsCard(meals: []) { _ in }
            .padding()
            .background(NutriColors.cream)
    }
}
