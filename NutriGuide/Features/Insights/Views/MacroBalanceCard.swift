import SwiftUI

struct MacroBalanceCard: View {
    let averages: MacroTargets

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Macro balance")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.text)

                VStack(alignment: .leading, spacing: 14) {
                    MacroBalanceLegendRow(title: "Protein", value: averages.protein, tint: NutriColors.protein)
                    MacroBalanceLegendRow(title: "Fat", value: averages.fat, tint: NutriColors.fat)
                    MacroBalanceLegendRow(title: "Carbs", value: averages.carbs, tint: NutriColors.carbs)
                }
            }

            Spacer(minLength: 8)

            MacroBalanceDonutChart(
                protein: averages.protein,
                fat: averages.fat,
                carbs: averages.carbs
            )
            .frame(width: 100, height: 100)
            .offset(y: 20)
        }
        .nutriSurfaceCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Macro balance seven day average")
    }
}

#Preview {
    MacroBalanceCard(averages: MacroTargets(calories: 0, protein: 72, fat: 58, carbs: 186))
        .padding()
        .background(NutriColors.cream)
}
