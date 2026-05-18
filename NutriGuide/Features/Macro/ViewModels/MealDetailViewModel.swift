import SwiftData

@MainActor
@Observable
final class MealDetailViewModel {
    var isEditing = false
    var showsDeleteConfirmation = false

    func deleteMeal(_ meal: MealEntry, in modelContext: ModelContext) {
        modelContext.delete(meal)
        try? modelContext.save()
    }
}
