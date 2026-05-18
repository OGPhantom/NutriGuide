import FoundationModels

@Generable
struct FoundationCoachRecommendationOutput {
    @Guide(description: "Soft food-level recommendation title, 3 to 6 words, no commands like reduce intake or increase intake.")
    var title: String

    @Guide(description: "One short food-level action. Mention a concrete food, meal moment, or swap. Do not mention day numbers or dates.")
    var body: String

    @Guide(description: "One SF Symbol name from: leaf, drop, fork.knife, carrot, figure.walk, target.")
    var symbolName: String
}
