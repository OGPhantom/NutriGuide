import SwiftUI

struct DiarySummaryCard: View {
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
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Text(totals.calories.formatted(.number.precision(.fractionLength(0))))
                    .font(.system(size: 42, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.oliveDark)
                    .contentTransition(.numericText())

                Text("/")
                    .font(.system(size: 24, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.text.opacity(0.72))

                Text(targets.calories.formatted(.number.precision(.fractionLength(0))))
                    .font(.system(size: 21, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.text)

                Text("kcal")
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)
            }

            NutriProgressBar(value: totals.calories, goal: targets.calories, height: 7)

            HStack(spacing: 8) {
                macroToken("Protein", value: totals.protein, tint: NutriColors.protein)
                macroSeparator
                macroToken("Fat", value: totals.fat, tint: NutriColors.fat)
                macroSeparator
                macroToken("Carbs", value: totals.carbs, tint: NutriColors.carbs)
            }
        }
        .nutriSurfaceCard(cornerRadius: 24, padding: 18)
    }

    private func macroToken(_ title: String, value: Double, tint: Color) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(tint)

            Text(value.gramsText)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private var macroSeparator: some View {
        Text("·")
            .font(NutriTypography.captionSemibold)
            .foregroundStyle(NutriColors.textMuted.opacity(0.65))
    }
}

#Preview {
    DiarySummaryCard(meals: PreviewFixtures.meals, targets: .preview)
        .padding()
        .background(NutriColors.cream)
}
