import Foundation

struct CoachInsightGeneratedContent: Equatable, Sendable {
    var headline: String
    var summary: String
    var recommendations: [CoachRecommendation]

    nonisolated init(
        headline: String,
        summary: String,
        recommendations: [CoachRecommendation]
    ) {
        self.headline = headline
        self.summary = summary
        self.recommendations = recommendations
    }
}
