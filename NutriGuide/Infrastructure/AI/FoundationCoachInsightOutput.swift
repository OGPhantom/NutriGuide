import FoundationModels

@Generable
struct FoundationCoachInsightOutput {
    @Guide(description: "A concise, editorial headline focused on the strongest nutrition pattern, 5 to 8 words, no colon, no alert wording")
    var headline: String

    @Guide(description: "Two short sentences explaining the insight in a warm wellness-coach tone.")
    var summary: String

    @Guide(description: "Exactly three practical recommendations.", .count(3))
    var recommendations: [FoundationCoachRecommendationOutput]
}
