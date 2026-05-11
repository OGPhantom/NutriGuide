import SwiftData
import SwiftUI

struct MealDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let meal: MealEntry

    @State private var isEditing = false
    @State private var showsDeleteConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    closeBar
                    header
                    macros
                    ingredients
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 118)
            }

            actions
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .sheet(isPresented: $isEditing) {
            MealEditSheet(meal: meal)
        }
        .confirmationDialog(
            "Delete this meal?",
            isPresented: $showsDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive, action: deleteMeal)
            Button("Continue editing", role: .cancel) {}
        }
    }

    private var closeBar: some View {
        HStack {
            NutriIconButton(
                title: "Close",
                systemImage: "xmark",
                size: 42,
                foreground: NutriColors.oliveDark,
                background: NutriColors.surface,
                action: { dismiss() }
            )

            Spacer()
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Label {
                Text("\(meal.loggedAt.metadataDayText()) • \(meal.loggedAt.mealTimeText())")
            } icon: {
                Image(systemName: meal.mealType.foodSymbol)
                    .foregroundStyle(meal.mealType.iconForeground)
            }
            .font(NutriTypography.captionSemibold)
            .foregroundStyle(NutriColors.textMuted)

            Text(meal.name)
                .font(NutriTypography.screenTitle)
                .foregroundStyle(NutriColors.oliveDark)
                .multilineTextAlignment(.center)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(meal.calories.formatted(.number.precision(.fractionLength(0))))
                    .font(NutriTypography.largeNumber)
                    .foregroundStyle(NutriColors.oliveDark)

                Text("kcal")
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var macros: some View {
        HStack(spacing: 10) {
            MacroMetricCard(title: "Protein", value: meal.protein, unit: "g", tint: NutriColors.olive)
            MacroMetricCard(title: "Fat", value: meal.fat, unit: "g", tint: NutriColors.apricot)
            MacroMetricCard(title: "Carbs", value: meal.carbs, unit: "g", tint: Color(hex: 0xE8B14F))
        }
    }

    private var ingredients: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ingredients")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            VStack(spacing: 0) {
                ForEach(Array(meal.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                    HStack {
                        Text(ingredient.name)
                            .font(NutriTypography.bodySemibold)
                            .foregroundStyle(NutriColors.text)

                        Spacer()

                        Text("\(ingredient.amount.portionText) \(ingredient.unit)")
                            .font(NutriTypography.body)
                            .foregroundStyle(NutriColors.textMuted)
                    }
                    .padding(.vertical, 12)

                    if index < meal.ingredients.count - 1 {
                        Divider()
                            .overlay(NutriColors.divider)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nutriSurfaceCard()
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button {
                isEditing = true
            } label: {
                Label("Edit", systemImage: "pencil")
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(NutriColors.olive)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Button {
                showsDeleteConfirmation = true
            } label: {
                Label("Delete", systemImage: "trash")
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(NutriColors.danger)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(NutriColors.surface)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(NutriColors.divider, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 24)
        .background(.ultraThinMaterial)
    }

    private func deleteMeal() {
        modelContext.delete(meal)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    MealDetailSheet(meal: PreviewFixtures.meals[0])
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}
