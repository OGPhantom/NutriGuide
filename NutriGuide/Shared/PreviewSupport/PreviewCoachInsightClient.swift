import Foundation

struct PreviewCoachInsightClient: CoachInsightGenerating {
    var availability: CoachInsightClientAvailability = .available
    var generatedContent = CoachInsightGeneratedContent(
        headline: "Your week is leaning light on protein",
        summary: "Your meals show a steady calorie rhythm, but protein is doing most of its work later in the day.",
        recommendations: PreviewFixtures.coachRecommendations
    )

    func generateInsight(for request: CoachInsightRequest) async throws -> CoachInsightGeneratedContent {
        generatedContent
    }
}
