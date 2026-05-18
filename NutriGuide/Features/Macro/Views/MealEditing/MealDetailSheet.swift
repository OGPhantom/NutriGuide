import SwiftData
import SwiftUI

struct MealDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let meal: MealEntry

    @State private var viewModel = MealDetailViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topArtwork
                    detailPanel
                }
                .padding(.bottom, 118)
            }

            actions
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .sheet(isPresented: $viewModel.isEditing) {
            MealEditSheet(meal: meal)
        }
        .confirmationDialog(
            "Delete this meal?",
            isPresented: $viewModel.showsDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive, action: deleteMeal)
            Button("Continue editing", role: .cancel) {}
        }
    }

    private var topArtwork: some View {
        ZStack(alignment: .top) {
            PremiumFoodRenderView(size: 220)
                .offset(y: -44)

            HStack {
                NutriIconButton(
                    title: "Close",
                    systemImage: "xmark",
                    size: 46,
                    foreground: NutriColors.oliveDark,
                    background: NutriColors.surface.opacity(0.94),
                    action: { dismiss() }
                )

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
        }
        .frame(height: 218)
    }

    private var detailPanel: some View {
        VStack(spacing: 24) {
            header
            macros
            ingredients
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
        .background(NutriColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        .shadow(color: NutriColors.oliveDark.opacity(0.08), radius: 26, x: 0, y: -4)
        .padding(.horizontal, 12)
        .padding(.top, -46)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Label {
                Text("\(meal.loggedAt.metadataDayText()) • \(meal.loggedAt.mealTimeText())")
            } icon: {
                Image(systemName: meal.mealType.foodSymbol)
                    .foregroundStyle(meal.mealType.iconForeground)
            }
            .font(NutriTypography.captionSemibold)
            .foregroundStyle(NutriColors.textMuted)

            Text(meal.name)
                .font(NutriTypography.mealTitle)
                .foregroundStyle(NutriColors.oliveDark)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.82)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(meal.calories.formatted(.number.precision(.fractionLength(0))))
                    .font(.system(size: 52, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.oliveDark)

                Text("kcal")
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var macros: some View {
        HStack(spacing: 12) {
            detailMetricCard(title: "Protein", value: meal.protein, unit: "g", tint: NutriColors.protein)
            detailMetricCard(title: "Fat", value: meal.fat, unit: "g", tint: NutriColors.fat)
            detailMetricCard(title: "Carbs", value: meal.carbs, unit: "g", tint: NutriColors.carbs)
        }
    }

    private var ingredients: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                Image(systemName: "leaf")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(NutriColors.olive)
                    .frame(width: 42, height: 42)
                    .background(NutriColors.apricotSoft.opacity(0.62))
                    .clipShape(Circle())

                Text("Ingredients")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.text)
            }

            ingredientList
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var ingredientList: some View {
        VStack(spacing: 0) {
            ForEach(Array(meal.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                ingredientRow(ingredient)
                    .padding(.vertical, 11)

                if index < meal.ingredients.count - 1 {
                    Rectangle()
                        .fill(NutriColors.divider.opacity(0.9))
                        .frame(height: 1)
                }
            }
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.isEditing = true
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
                viewModel.showsDeleteConfirmation = true
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
        .background(NutriColors.surface.opacity(0.96))
    }

    private func deleteMeal() {
        viewModel.deleteMeal(meal, in: modelContext)
        dismiss()
    }

    private func detailMetricCard(title: String, value: Double, unit: String, tint: Color) -> some View {
        VStack(spacing: 9) {
            Text(title)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value.formatted(.number.precision(.fractionLength(0))))
                    .font(.system(size: 31, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.oliveDark)

                Text(unit)
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)
            }

            NutriProgressBar(value: value, goal: max(value * 1.55, 1), tint: tint, height: 5)
                .frame(width: 74)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(NutriColors.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(NutriColors.divider.opacity(0.72), lineWidth: 1)
        )
        .shadow(color: NutriColors.oliveDark.opacity(0.04), radius: 14, x: 0, y: 8)
    }

    private func ingredientRow(_ ingredient: MealIngredient) -> some View {
        HStack(spacing: 14) {
            Text(ingredient.name)
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(NutriColors.text)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            Spacer(minLength: 8)

            Text("\(ingredient.amount.portionText) \(ingredient.unit)")
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(NutriColors.textMuted)
                .lineLimit(1)
        }
    }
}

#Preview {
    MealDetailSheet(meal: PreviewFixtures.meals[0])
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}
