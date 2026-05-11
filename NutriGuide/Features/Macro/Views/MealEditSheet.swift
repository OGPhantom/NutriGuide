import SwiftData
import SwiftUI

struct MealEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let meal: MealEntry

    @State private var name: String
    @State private var calories: Double
    @State private var protein: Double
    @State private var fat: Double
    @State private var carbs: Double
    @State private var mealType: MealType
    @State private var ingredients: [IngredientDraft]

    init(meal: MealEntry) {
        self.meal = meal
        _name = State(initialValue: meal.name)
        _calories = State(initialValue: meal.calories)
        _protein = State(initialValue: meal.protein)
        _fat = State(initialValue: meal.fat)
        _carbs = State(initialValue: meal.carbs)
        _mealType = State(initialValue: meal.mealType)
        _ingredients = State(initialValue: meal.ingredients.map {
            IngredientDraft(id: $0.id, name: $0.name, amount: $0.amount, unit: $0.unit, calories: $0.calories)
        })
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    textField("Meal name", text: $name)

                    numericSection
                    mealTypeSection
                    IngredientDraftEditorList(ingredients: $ingredients)
                }
                .padding(20)
                .padding(.bottom, 90)
            }
            .background(NutriColors.cream.ignoresSafeArea())
            .navigationTitle("Edit meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: { dismiss() })
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var numericSection: some View {
        VStack(spacing: 14) {
            numberField("Calories", value: $calories, unit: "kcal")
            numberField("Protein", value: $protein, unit: "g")
            numberField("Fat", value: $fat, unit: "g")
            numberField("Carbs", value: $carbs, unit: "g")
        }
        .nutriSurfaceCard()
    }

    private var mealTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meal type")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            HStack(spacing: 8) {
                ForEach(MealType.allCases) { type in
                    NutriFilterChip(
                        title: type.title,
                        isSelected: mealType == type,
                        action: { mealType = type }
                    )
                }
            }
        }
        .nutriSurfaceCard()
    }

    private func textField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)

            TextField(title, text: text)
                .font(NutriTypography.body)
                .padding(14)
                .background(NutriColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private func numberField(_ title: String, value: Binding<Double>, unit: String) -> some View {
        HStack {
            Text(title)
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(NutriColors.text)

            Spacer()

            TextField(title, value: value, format: .number.precision(.fractionLength(0)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(NutriTypography.body)
                .frame(width: 90)

            Text(unit)
                .font(NutriTypography.caption)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private func save() {
        meal.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        meal.calories = calories
        meal.protein = protein
        meal.fat = fat
        meal.carbs = carbs
        meal.mealType = mealType

        for ingredient in meal.ingredients {
            modelContext.delete(ingredient)
        }

        meal.ingredients = ingredients.map {
            MealIngredient(name: $0.name, amount: $0.amount, unit: $0.unit, calories: $0.calories, meal: meal)
        }

        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    MealEditSheet(meal: PreviewFixtures.meals[0])
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}
