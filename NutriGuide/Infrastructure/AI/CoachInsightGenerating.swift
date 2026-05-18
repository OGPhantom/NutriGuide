import Foundation

protocol CoachInsightGenerating: Sendable {
    var availability: CoachInsightClientAvailability { get }

    func generateInsight(for request: CoachInsightRequest) async throws -> CoachInsightGeneratedContent
}
