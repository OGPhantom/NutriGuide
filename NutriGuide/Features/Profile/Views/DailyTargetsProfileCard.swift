import SwiftUI

struct DailyTargetsProfileCard: View {
    let profile: UserProfile
    let action: () -> Void

    private enum Layout {
        static let caloriesWidth: CGFloat = 92
        static let mainSpacing: CGFloat = 14
        static let macroSpacing: CGFloat = 8
    }

    private var targets: MacroTargets {
        profile.dailyTargets
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Daily Targets")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                HStack(alignment: .bottom, spacing: Layout.mainSpacing) {
                    calorieColumn
                        .frame(width: Layout.caloriesWidth, alignment: .leading)

                    Rectangle()
                        .fill(NutriColors.divider)
                        .frame(width: 1, height: 58)

                    macroTargetsRow
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .nutriSurfaceCard()
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit daily targets")
    }

    private var calorieColumn: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(targets.calories.formatted(.number.precision(.fractionLength(0))))
                    .font(.system(size: 30, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.oliveDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.74)

                Text("kcal")
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)
            }

            Text("Calories")
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private var macroTargetsRow: some View {
        HStack(alignment: .bottom, spacing: Layout.macroSpacing) {
            macroColumn(title: "Protein", value: targets.protein, tint: NutriColors.protein)
            macroColumn(title: "Fat", value: targets.fat, tint: NutriColors.fat)
            macroColumn(title: "Carbs", value: targets.carbs, tint: NutriColors.carbs)
        }
        .frame(maxWidth: .infinity)
    }

    private func macroColumn(title: String, value: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value.formatted(.number.precision(.fractionLength(0))))
                    .font(.system(.title3, design: .serif).weight(.regular))
                    .foregroundStyle(NutriColors.oliveDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Text("g")
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)
            }

            Text(title)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.78)

            Capsule()
                .fill(tint)
                .frame(height: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DailyTargetsProfileCard(profile: UserProfile()) {}
        .padding()
        .background(NutriColors.cream)
}
