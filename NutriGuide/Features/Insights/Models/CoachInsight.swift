import Foundation
import SwiftData

@Model
final class CoachInsight {
    static let latestID = "latest-coach-insight"

    @Attribute(.unique) var id: String
    var createdAt: Date
    var periodStart: Date
    var periodEnd: Date
    var headline: String
    var summary: String
    var averageProtein: Double
    var averageFat: Double
    var averageCarbs: Double
    var recommendationsData: Data

    init(
        id: String = CoachInsight.latestID,
        createdAt: Date = .now,
        periodStart: Date,
        periodEnd: Date,
        headline: String,
        summary: String,
        averageProtein: Double,
        averageFat: Double,
        averageCarbs: Double,
        recommendations: [CoachRecommendation]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.headline = headline
        self.summary = summary
        self.averageProtein = averageProtein
        self.averageFat = averageFat
        self.averageCarbs = averageCarbs
        self.recommendationsData = (try? JSONEncoder().encode(recommendations)) ?? Data()
    }
}

extension CoachInsight {
    var recommendations: [CoachRecommendation] {
        get {
            (try? JSONDecoder().decode([CoachRecommendation].self, from: recommendationsData)) ?? []
        }
        set {
            recommendationsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    var macroAverages: MacroTargets {
        MacroTargets(
            calories: 0,
            protein: averageProtein,
            fat: averageFat,
            carbs: averageCarbs
        )
    }

    func update(
        with generatedContent: CoachInsightGeneratedContent,
        request: CoachInsightRequest,
        createdAt: Date = .now
    ) {
        self.createdAt = createdAt
        periodStart = request.periodStart
        periodEnd = request.periodEnd
        headline = generatedContent.headline
        summary = generatedContent.summary
        averageProtein = request.averageProtein
        averageFat = request.averageFat
        averageCarbs = request.averageCarbs
        recommendations = Array(generatedContent.recommendations.prefix(3))
    }
}
