import SwiftUI

struct MacroBalanceLegendRow: View {
    let title: String
    let value: Double
    let tint: Color

    var body: some View {
        HStack(spacing: 11) {
            Circle()
                .fill(tint)
                .frame(width: 9, height: 9)

            Text(title)
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.textMuted)

            Spacer(minLength: 12)

            Text(value.gramsText)
                .font(.system(.body, design: .serif).weight(.semibold))
                .foregroundStyle(NutriColors.text)
                .contentTransition(.numericText())
        }
    }
}

#Preview {
    MacroBalanceLegendRow(title: "Protein", value: 72, tint: NutriColors.protein)
        .padding()
        .background(NutriColors.cream)
}
