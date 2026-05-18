import SwiftData
import SwiftUI

struct MealEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let meal: MealEntry

    @State private var viewModel: MealEditViewModel

    init(meal: MealEntry) {
        self.meal = meal
        _viewModel = State(initialValue: MealEditViewModel(meal: meal))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    textField("Meal name", text: $viewModel.name)

                    numericSection(
                        calories: $viewModel.calories,
                        protein: $viewModel.protein,
                        fat: $viewModel.fat,
                        carbs: $viewModel.carbs
                    )
                    mealTypeSection(mealType: $viewModel.mealType)
                    IngredientDraftEditorList(ingredients: $viewModel.ingredients)
                }
                .padding(20)
                .padding(.bottom, 90)
            }
            .background(NutriColors.cream.ignoresSafeArea())
            .navigationTitle("Edit meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(NutriColors.cream, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .tint(NutriColors.olive)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: { dismiss() })
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                        .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.light)
        }
    }

    private func numericSection(
        calories: Binding<Double>,
        protein: Binding<Double>,
        fat: Binding<Double>,
        carbs: Binding<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Nutrition")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            numberField("Calories", value: calories, unit: "kcal")
            numberField("Protein", value: protein, unit: "g")
            numberField("Fat", value: fat, unit: "g")
            numberField("Carbs", value: carbs, unit: "g")
        }
        .nutriSurfaceCard()
    }

    private func mealTypeSection(mealType: Binding<MealType>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meal type")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            HStack {
                ForEach(MealType.allCases) { type in
                    NutriFilterChip(
                        title: type.title,
                        isSelected: mealType.wrappedValue == type,
                        action: { mealType.wrappedValue = type }
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .nutriSurfaceCard()
    }

    private func textField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            TextField(title, text: text)
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.text)
                .tint(NutriColors.olive)
                .padding(14)
                .background(NutriColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    Capsule()
                        .stroke(NutriColors.divider.opacity(0.65), lineWidth: 1)
                )
        }
        .nutriSurfaceCard()
    }

    private func numberField(_ title: String, value: Binding<Double>, unit: String) -> some View {
        HStack {
            Text(title)
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.text)
                .tint(NutriColors.olive)

            Spacer()

            TextField(title, value: value, format: .number.precision(.fractionLength(0)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.text)
                .tint(NutriColors.olive)
                .frame(width: 90)

            Text(unit)
                .font(NutriTypography.caption)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private func save() {
        viewModel.save(meal: meal, in: modelContext)
        dismiss()
    }
}

#Preview {
    MealEditSheet(meal: PreviewFixtures.meals[0])
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}
