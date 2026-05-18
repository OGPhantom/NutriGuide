import SwiftUI

struct DailySummaryCard: View {
    let meals: [MealEntry]
    let targets: MacroTargets

    private var totals: MacroTargets {
        meals.reduce(MacroTargets(calories: 0, protein: 0, fat: 0, carbs: 0)) { partial, meal in
            MacroTargets(
                calories: partial.calories + meal.calories,
                protein: partial.protein + meal.protein,
                fat: partial.fat + meal.fat,
                carbs: partial.carbs + meal.carbs
            )
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(totals.calories.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(size: 48, weight: .regular, design: .serif))
                        .foregroundStyle(NutriColors.oliveDark)
                        .contentTransition(.numericText())

                    Text("/")
                        .font(.system(size: 28, weight: .regular, design: .serif))
                        .foregroundStyle(NutriColors.text.opacity(0.72))

                    Text(targets.calories.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(size: 24, weight: .regular, design: .serif))
                        .foregroundStyle(NutriColors.text)

                    Text("kcal")
                        .font(NutriTypography.bodySemibold)
                        .foregroundStyle(NutriColors.textMuted)
                }

                NutriProgressBar(value: totals.calories, goal: targets.calories, height: 8)
            }

            HStack(alignment: .top, spacing: 22) {
                macroColumn(title: "Protein", value: totals.protein, goal: targets.protein, tint: NutriColors.protein)
                macroColumn(title: "Fat", value: totals.fat, goal: targets.fat, tint: NutriColors.fat)
                macroColumn(title: "Carbs", value: totals.carbs, goal: targets.carbs, tint: NutriColors.carbs)
            }
        }
        .nutriSurfaceCard()
    }

    private func macroColumn(title: String, value: Double, goal: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title)
                .font(.system(.callout, design: .rounded).weight(.medium))
                .foregroundStyle(NutriColors.text)

            Text("\(value.gramsText) / \(goal.gramsText)")
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            NutriProgressBar(value: value, goal: goal, tint: tint, height: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DailySummaryCard(meals: PreviewFixtures.meals, targets: .preview)
        .padding()
        .background(NutriColors.cream)
}
