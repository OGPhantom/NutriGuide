import SwiftUI

struct MacroMetricCard: View {
    let title: String
    let value: Double
    let unit: String
    var tint: Color = NutriColors.olive
    var showsEditAffordance = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(title)
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)

                if showsEditAffordance {
                    Image(systemName: "pencil")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(NutriColors.textMuted)
                        .accessibilityHidden(true)
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value.formatted(.number.precision(.fractionLength(0))))
                    .font(NutriTypography.mealTitle)
                    .foregroundStyle(NutriColors.text)

                Text(unit)
                    .font(NutriTypography.caption)
                    .foregroundStyle(NutriColors.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(NutriColors.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(alignment: .bottomLeading) {
            Capsule()
                .fill(tint.opacity(0.7))
                .frame(width: 38, height: 3)
                .padding(.leading, 14)
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    HStack {
        MacroMetricCard(title: "Protein", value: 38, unit: "g", showsEditAffordance: true)
        MacroMetricCard(title: "Fat", value: 18, unit: "g", tint: NutriColors.apricot)
    }
    .padding()
    .background(NutriColors.cream)
}
