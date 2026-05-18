import SwiftData
import SwiftUI

@MainActor
@Observable
final class HomeViewModel {
    var presentedFlow: MealFlowDestination?
    var toast: NutriToast?

    func greetingText(for date: Date = .now, calendar: Calendar = .current) -> String {
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 5..<12:
            return "Good morning,"
        case 12..<17:
            return "Good afternoon,"
        case 17..<22:
            return "Good evening,"
        default:
            return "Good night,"
        }
    }

    var isFlowPresented: Bool {
        presentedFlow != nil
    }

    func setFlowPresented(_ isPresented: Bool) {
        if !isPresented {
            presentedFlow = nil
        }
    }

    func seedDefaultProfileIfNeeded(in modelContext: ModelContext) {
        try? ProfileSeedService.seedDefaultProfileIfNeeded(in: modelContext)
    }

    func openCamera() {
        presentedFlow = .camera
    }

    func showDetail(for meal: MealEntry) {
        presentedFlow = .detail(meal)
    }

    func handleCapturedPhoto(_ data: Data) {
        presentedFlow = .analyzing(CapturedMealPhoto(data: data))
    }

    func handleAnalysisComplete(_ analysis: FoodAnalysisDraft, photo: CapturedMealPhoto) {
        presentedFlow = .review(photo, analysis)
    }

    func closeFlow() {
        presentedFlow = nil
    }

    func retakePhoto() {
        presentedFlow = .camera
    }

    func reviewDraft(for analysis: FoodAnalysisDraft) -> ReviewMealDraft {
        ReviewMealDraft(
            analysis: analysis,
            mealType: MealType.suggested(for: .now),
            loggedAt: .now
        )
    }

    func saveReviewedMeal(_ draft: ReviewMealDraft, in modelContext: ModelContext) {
        let ingredients = draft.ingredients.map {
            MealIngredient(name: $0.name, amount: $0.amount, unit: $0.unit, calories: $0.calories)
        }

        let meal = MealEntry(
            name: draft.name,
            calories: draft.calories,
            protein: draft.protein,
            fat: draft.fat,
            carbs: draft.carbs,
            loggedAt: draft.loggedAt,
            mealType: draft.mealType,
            ingredients: ingredients
        )

        modelContext.insert(meal)
        try? modelContext.save()

        presentedFlow = nil
        showMealSavedToast()
    }

    private func showMealSavedToast() {
        withAnimation(.smooth(duration: 0.24)) {
            toast = NutriToast(message: "Meal saved", systemImage: "checkmark.circle.fill")
        }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))

            withAnimation(.smooth(duration: 0.24)) {
                toast = nil
            }
        }
    }
}
