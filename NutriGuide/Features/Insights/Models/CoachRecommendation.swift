import Foundation

struct CoachRecommendation: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var title: String
    var body: String
    var symbolName: String

    nonisolated init(
        id: UUID = UUID(),
        title: String,
        body: String,
        symbolName: String = "leaf"
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.symbolName = symbolName
    }
}
