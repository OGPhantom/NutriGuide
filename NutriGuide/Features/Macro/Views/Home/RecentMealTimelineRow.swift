import SwiftUI

struct RecentMealTimelineRow: View {
    let meal: MealEntry
    let isLast: Bool
    var showsDateForNonToday = true
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: Self.columnSpacing) {
                timeColumn

                timelineDot
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 0) {
                    Text(meal.name)
                        .font(NutriTypography.mealTitle)
                        .foregroundStyle(NutriColors.text)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)


                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(meal.mealType.title)
                            .font(NutriTypography.captionSemibold)
                            .foregroundStyle(NutriColors.textMuted)

                        Spacer()

                        Text(meal.calories.kcalText)
                            .font(NutriTypography.captionSemibold)
                            .foregroundStyle(NutriColors.textMuted)
                    }
                    .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 16)
            .contentShape(Rectangle())
            .background(alignment: .leading) {
                timelineLine
            }
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(NutriColors.divider.opacity(0.8))
                    .frame(height: 1)
                    .padding(.leading, 72)
            }
        }
    }

    private var timeColumn: some View {
        Text(timeColumnText)
            .font(NutriTypography.captionSemibold)
            .foregroundStyle(NutriColors.text)
            .lineLimit(1)
            .minimumScaleFactor(0.78)
            .frame(width: Self.timeColumnWidth, alignment: .trailing)
    }

    private var timelineDot: some View {
        Circle()
            .fill(NutriColors.olive)
            .frame(width: 11, height: 11)
            .overlay(Circle().stroke(NutriColors.surface, lineWidth: 3))
            .frame(width: Self.timelineColumnWidth, height: Self.timelineColumnWidth)
    }

    private var timelineLine: some View {
        GeometryReader { proxy in
            Path { path in
                let x = Self.timeColumnWidth + Self.columnSpacing + Self.timelineColumnWidth / 2
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: proxy.size.height))
            }
            .stroke(NutriColors.divider, lineWidth: 1)
        }
        .allowsHitTesting(false)
    }

    private var timeColumnText: String {
        if !showsDateForNonToday || meal.loggedAt.recentRelativeDayText() == nil {
            return meal.loggedAt.mealTimeText()
        }

        return meal.loggedAt.formatted(.dateTime.month(.abbreviated).day())
    }

    private static let timeColumnWidth: CGFloat = 44
    private static let timelineColumnWidth: CGFloat = 12
    private static let columnSpacing: CGFloat = 8
}

#Preview {
    RecentMealTimelineRow(meal: PreviewFixtures.meals[0], isLast: false) {}
        .padding()
        .background(NutriColors.surface)
}
