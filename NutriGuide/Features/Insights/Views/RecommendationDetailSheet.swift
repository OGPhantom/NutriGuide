import SwiftUI

struct RecommendationDetailSheet: View {
    @Environment(\.dismiss) private var dismiss

    let recommendation: CoachRecommendation

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            header

            VStack(alignment: .leading, spacing: 16) {
                icon

                Text(recommendation.title)
                    .font(.system(size: 32, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.oliveDark)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(recommendation.body)
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.textMuted)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 22)
        .padding(.bottom, 18)
        .background(NutriColors.surface)
    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Recommendation")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            Spacer()

            Button("Close", systemImage: "xmark", action: dismiss.callAsFunction)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .labelStyle(.iconOnly)
                .foregroundStyle(NutriColors.olive)
                .frame(width: 42, height: 42)
                .background(NutriColors.oliveSoft.opacity(0.72))
                .clipShape(Circle())
                .buttonStyle(.plain)
                .accessibilityLabel("Close recommendation")
        }
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(NutriColors.apricotSoft.opacity(0.58))
                .frame(width: 62, height: 62)

            Image(systemName: recommendation.symbolName)
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(NutriColors.olive)
        }
    }
}

#Preview {
    RecommendationDetailSheet(recommendation: PreviewFixtures.coachRecommendations[0])
        .background(NutriColors.cream)
}
