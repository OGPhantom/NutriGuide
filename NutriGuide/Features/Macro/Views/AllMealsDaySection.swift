import SwiftUI

struct AllMealsDaySection: View {
    let day: Date
    let meals: [MealEntry]
    let onSelectMeal: (MealEntry) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dayHeader)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                ForEach(Array(meals.enumerated()), id: \.element.id) { index, meal in
                    RecentMealTimelineRow(
                        meal: meal,
                        isLast: index == meals.count - 1,
                        onSelect: { onSelectMeal(meal) }
                    )
                }
            }
            .nutriSurfaceCard()
        }
    }

    private var dayHeader: String {
        if Calendar.current.isDateInToday(day) {
            return "Today"
        }

        if Calendar.current.isDateInYesterday(day) {
            return "Yesterday"
        }

        return day.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    }
}

#Preview {
    AllMealsDaySection(day: .now, meals: PreviewFixtures.meals) { _ in }
        .padding()
        .background(NutriColors.cream)
}
