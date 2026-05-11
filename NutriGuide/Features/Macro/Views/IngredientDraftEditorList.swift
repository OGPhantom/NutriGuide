import SwiftUI

struct IngredientDraftEditorList: View {
    @Binding var ingredients: [IngredientDraft]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ingredients")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.text)

                Spacer()

                Button("Add", systemImage: "plus") {
                    ingredients.append(IngredientDraft(name: "", amount: 0, unit: "g"))
                }
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.olive)
            }

            VStack(spacing: 14) {
                ForEach($ingredients) { $ingredient in
                    HStack(alignment: .top, spacing: 12) {
                        VStack(spacing: 10) {
                            TextField("Ingredient", text: $ingredient.name)
                                .font(NutriTypography.bodySemibold)

                            HStack {
                                TextField("Amount", value: $ingredient.amount, format: .number)
                                    .keyboardType(.decimalPad)

                                TextField("Unit", text: $ingredient.unit)
                                    .frame(width: 52)
                            }
                            .font(NutriTypography.body)
                            .foregroundStyle(NutriColors.textMuted)
                        }

                        Button("Remove", systemImage: "minus.circle") {
                            ingredients.removeAll { $0.id == ingredient.id }
                        }
                        .labelStyle(.iconOnly)
                        .foregroundStyle(NutriColors.danger)
                        .accessibilityLabel("Remove ingredient")
                    }
                    .padding(14)
                    .background(NutriColors.elevatedSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
            }
        }
        .nutriSurfaceCard()
    }
}

#Preview {
    IngredientDraftEditorList(ingredients: .constant(FoodAnalysisDraft.preview.ingredients))
        .padding()
        .background(NutriColors.cream)
}
