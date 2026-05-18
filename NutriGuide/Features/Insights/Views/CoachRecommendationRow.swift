import SwiftUI

struct CoachRecommendationRow: View {
    let recommendation: CoachRecommendation

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(NutriColors.apricotSoft.opacity(0.55))
                    .frame(width: 52, height: 52)

                Image(systemName: recommendation.symbolName)
                    .font(.system(size: 21, weight: .medium))
                    .foregroundStyle(NutriColors.olive)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(recommendation.title)
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(NutriColors.text)
                    .lineLimit(2)

                Text(recommendation.body)
                    .font(NutriTypography.caption)
                    .foregroundStyle(NutriColors.textMuted)
                    .lineLimit(3)
                    .lineSpacing(2)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .background(NutriColors.elevatedSurface.opacity(0.82))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(NutriColors.divider.opacity(0.72), lineWidth: 1)
        )
    }
}

#Preview {
    CoachRecommendationRow(recommendation: PreviewFixtures.coachRecommendations[0])
        .padding()
        .background(NutriColors.cream)
}
