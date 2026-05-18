import SwiftData
import SwiftUI

struct EditDailyTargetsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var calories: Double
    @State private var protein: Double
    @State private var fat: Double
    @State private var carbs: Double

    init(profile: UserProfile) {
        self.profile = profile
        _calories = State(initialValue: profile.targetCalories)
        _protein = State(initialValue: profile.targetProtein)
        _fat = State(initialValue: profile.targetFat)
        _carbs = State(initialValue: profile.targetCarbs)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    targetsSection

                    Button {
                        calculateFromProfile()
                    } label: {
                        Text("Calculate from profile")
                            .font(NutriTypography.bodySemibold)
                            .foregroundStyle(NutriColors.olive)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(NutriColors.oliveSoft)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(NutriColors.cream.ignoresSafeArea())
            .navigationTitle("Daily targets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(NutriColors.cream, for: .navigationBar)
            .tint(NutriColors.olive)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var targetsSection: some View {
        VStack(spacing: 14) {
            numberField("Calories", value: $calories, unit: "kcal")
            numberField("Protein", value: $protein, unit: "g")
            numberField("Fat", value: $fat, unit: "g")
            numberField("Carbs", value: $carbs, unit: "g")
        }
        .nutriSurfaceCard()
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
                .foregroundStyle(NutriColors.text)
                .tint(NutriColors.olive)
                .frame(width: 90)

            Text(unit)
                .font(NutriTypography.caption)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private func calculateFromProfile() {
        let calculatedTargets = profile.calculatedTargetsFromProfile
        calories = calculatedTargets.calories
        protein = calculatedTargets.protein
        fat = calculatedTargets.fat
        carbs = calculatedTargets.carbs
    }

    private func save() {
        profile.targetCalories = max(1, calories)
        profile.targetProtein = max(0, protein)
        profile.targetFat = max(0, fat)
        profile.targetCarbs = max(0, carbs)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    EditDailyTargetsSheet(profile: UserProfile())
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
