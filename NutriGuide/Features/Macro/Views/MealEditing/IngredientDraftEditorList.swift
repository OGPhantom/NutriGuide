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
                    HStack(alignment: .center, spacing: 12) {
                        TextField("Ingredient", text: $ingredient.name)
                            .font(NutriTypography.bodySemibold)
                            .foregroundStyle(NutriColors.text)
                            .tint(NutriColors.olive)

                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                TextField("Amount", value: $ingredient.amount, format: .number)
                                    .keyboardType(.decimalPad)
                                    .font(NutriTypography.body)
                                    .foregroundStyle(NutriColors.textMuted)
                                    .tint(NutriColors.olive)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 54)

                                Text(ingredient.unit)
                                    .font(NutriTypography.body)
                                    .foregroundStyle(NutriColors.textMuted)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(NutriColors.surface)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(NutriColors.divider.opacity(0.65), lineWidth: 1)
                            )


                        Button("Remove", systemImage: "minus.circle") {
                            withAnimation{
                                ingredients.removeAll { $0.id == ingredient.id }
                            }
                        }
                        .labelStyle(.iconOnly)
                        .foregroundStyle(NutriColors.danger)
                        .accessibilityLabel("Remove ingredient")
                    }
                    .padding(14)
                    .background(NutriColors.elevatedSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(NutriColors.divider.opacity(0.65), lineWidth: 1)
                    )
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
