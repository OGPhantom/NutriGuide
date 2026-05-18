import SwiftUI

struct RecommendationsCard: View {
    let recommendations: [CoachRecommendation]

    @State private var selectedRecommendation: CoachRecommendation?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            if recommendations.isEmpty {
                Text("Generate an insight to see three personalized recommendations.")
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.textMuted)
                    .lineSpacing(3)
                    .padding(.vertical, 6)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(recommendations.prefix(3))) { recommendation in
                        Button {
                            selectedRecommendation = recommendation
                        } label: {
                            CoachRecommendationRow(recommendation: recommendation)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(recommendation.title)
                        .accessibilityHint("Opens recommendation details")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nutriSurfaceCard()
        .sheet(item: $selectedRecommendation) { recommendation in
            RecommendationDetailSheet(recommendation: recommendation)
                .presentationDragIndicator(.visible)
                .presentationBackground(NutriColors.surface)
        }
    }
}

#Preview("Loaded") {
    RecommendationsCard(recommendations: PreviewFixtures.coachRecommendations)
        .padding()
        .background(NutriColors.cream)
}

#Preview("Empty") {
    RecommendationsCard(recommendations: [])
        .padding()
        .background(NutriColors.cream)
}
