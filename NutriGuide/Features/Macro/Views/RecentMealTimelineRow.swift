import SwiftUI

struct RecentMealTimelineRow: View {
    let meal: MealEntry
    let isLast: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: 14) {
                timeColumn

                ZStack(alignment: .top) {
                    if !isLast {
                        Rectangle()
                            .fill(NutriColors.olive.opacity(0.26))
                            .frame(width: 1)
                            .padding(.top, 30)
                    }

                    Circle()
                        .fill(NutriColors.olive)
                        .frame(width: 11, height: 11)
                        .overlay(Circle().stroke(NutriColors.surface, lineWidth: 3))
                }
                .frame(width: 14)
                .frame(maxHeight: .infinity)

                MealTypeIconView(mealType: meal.mealType, size: 42)

                VStack(alignment: .leading, spacing: 0) {
                    Text(meal.name)
                        .font(NutriTypography.mealTitle)
                        .foregroundStyle(NutriColors.text)
                        .lineLimit(2)
                        .frame(minHeight: 46, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text(meal.calories.kcalText)
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(NutriColors.text)
                    .lineLimit(1)
                    .padding(.top, 1)
            }
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(NutriColors.divider.opacity(0.8))
                    .frame(height: 1)
                    .padding(.leading, 96)
            }
        }
    }

    private var timeColumn: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(meal.loggedAt.mealTimeText())
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.text)
                .lineLimit(1)

            if let relativeDay = meal.loggedAt.recentRelativeDayText() {
                Text(relativeDay)
                    .font(NutriTypography.caption)
                    .foregroundStyle(NutriColors.textMuted)
                    .lineLimit(1)
            }
        }
        .frame(width: 64, alignment: .trailing)
    }
}

#Preview {
    RecentMealTimelineRow(meal: PreviewFixtures.meals[0], isLast: false) {}
        .padding()
        .background(NutriColors.surface)
}
