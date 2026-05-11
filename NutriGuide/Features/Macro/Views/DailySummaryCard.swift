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
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Text(totals.calories.formatted(.number.precision(.fractionLength(0))))
                    .font(NutriTypography.largeNumber)
                    .foregroundStyle(NutriColors.text)

                Text("/ \(targets.calories.formatted(.number.precision(.fractionLength(0)))) kcal")
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(NutriColors.textMuted)
            }

            NutriProgressBar(value: totals.calories, goal: targets.calories)

            VStack(spacing: 14) {
                macroRow(title: "Protein", value: totals.protein, goal: targets.protein, tint: NutriColors.olive)
                macroRow(title: "Fat", value: totals.fat, goal: targets.fat, tint: NutriColors.apricot)
                macroRow(title: "Carbs", value: totals.carbs, goal: targets.carbs, tint: Color(hex: 0xE8B14F))
            }
        }
        .nutriSurfaceCard()
    }

    private func macroRow(title: String, value: Double, goal: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(title)
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)

                Spacer()

                Text("\(value.gramsText) / \(goal.gramsText)")
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.text)
            }

            NutriProgressBar(value: value, goal: goal, tint: tint, height: 5)
        }
    }
}

#Preview {
    DailySummaryCard(meals: PreviewFixtures.meals, targets: .preview)
        .padding()
        .background(NutriColors.cream)
}
