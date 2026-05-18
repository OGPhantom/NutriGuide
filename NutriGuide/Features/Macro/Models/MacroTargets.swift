import Foundation

struct MacroTargets: Equatable {
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double

    static let preview = MacroTargets(
        calories: 2_200,
        protein: 150,
        fat: 70,
        carbs: 250
    )
}
