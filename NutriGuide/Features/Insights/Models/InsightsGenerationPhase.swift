import Foundation

enum InsightsGenerationPhase: Equatable {
    case idle
    case generating
    case failed(String)
}
