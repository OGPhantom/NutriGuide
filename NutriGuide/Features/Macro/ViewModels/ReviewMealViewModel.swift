import Foundation

@MainActor
@Observable
final class ReviewMealViewModel {
    var draft: ReviewMealDraft
    var showsDiscardConfirmation = false
    var isEditingTitle = false
    var isEditingCalories = false
    var isEditingIngredients = false
    var editingMacro: MacroKind?
    var temporaryMacroValue = 0.0

    init(initialDraft: ReviewMealDraft) {
        draft = initialDraft
    }

    func beginMacroEdit(kind: MacroKind, value: Double) {
        editingMacro = kind
        temporaryMacroValue = value
    }

    func applyMacroEdit() {
        switch editingMacro {
        case .protein:
            draft.protein = temporaryMacroValue
        case .fat:
            draft.fat = temporaryMacroValue
        case .carbs:
            draft.carbs = temporaryMacroValue
        case .calories:
            draft.calories = temporaryMacroValue
        case nil:
            break
        }

        editingMacro = nil
    }
}
