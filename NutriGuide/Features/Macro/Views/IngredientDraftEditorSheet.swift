import SwiftUI

struct IngredientDraftEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var ingredients: [IngredientDraft]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                IngredientDraftEditorList(ingredients: $ingredients)
                    .padding(20)
            }
            .background(NutriColors.cream.ignoresSafeArea())
            .navigationTitle("Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: { dismiss() })
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    IngredientDraftEditorSheet(ingredients: .constant(FoodAnalysisDraft.preview.ingredients))
}
