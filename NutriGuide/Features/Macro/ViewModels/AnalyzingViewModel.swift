import Foundation

enum AnalyzingPhase {
    case loading
    case failed
}

@MainActor
@Observable
final class AnalyzingViewModel {
    var phase: AnalyzingPhase = .loading

    private let client: OpenAIFoodAnalysisClient

    init(client: OpenAIFoodAnalysisClient = OpenAIFoodAnalysisClient()) {
        self.client = client
    }

    func analyze(photo: CapturedMealPhoto) async -> FoodAnalysisDraft? {
        phase = .loading

        do {
            let analysis = try await client.analyzeFoodImage(photo.data)
            try Task.checkCancellation()
            return analysis
        } catch is CancellationError {
            return nil
        } catch {
            guard !Task.isCancelled else { return nil }
            phase = .failed
            return nil
        }
    }
}
