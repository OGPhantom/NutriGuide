import SwiftData
import SwiftUI

struct EditBodyProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var sex: Sex
    @State private var age: Int
    @State private var heightCentimeters: Double
    @State private var heightFeet: Int
    @State private var heightInches: Int
    @State private var weightValue: Double

    init(profile: UserProfile) {
        self.profile = profile
        let totalInches = ProfileMeasurementFormatter.totalInches(fromCentimeters: profile.heightCentimeters)
        _sex = State(initialValue: profile.sex)
        _age = State(initialValue: profile.age)
        _heightCentimeters = State(initialValue: profile.heightCentimeters)
        _heightFeet = State(initialValue: totalInches / 12)
        _heightInches = State(initialValue: totalInches % 12)
        _weightValue = State(
            initialValue: profile.unitSystem == .metric
                ? profile.weightKilograms
                : ProfileMeasurementFormatter.pounds(fromKilograms: profile.weightKilograms)
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    sexSection
                    metricsSection
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(NutriColors.cream.ignoresSafeArea())
            .navigationTitle("Body profile")
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

    private var sexSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sex")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            HStack(spacing: 0) {
                ForEach(Sex.allCases) { option in
                    sexOption(option)
                }
            }
            .padding(4)
            .background(NutriColors.elevatedSurface.opacity(0.84))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(NutriColors.divider.opacity(0.72), lineWidth: 1)
            }
        }
        .nutriSurfaceCard()
    }

    private func sexOption(_ option: Sex) -> some View {
        let isSelected = sex == option

        return Button {
            withAnimation(.snappy(duration: 0.22)) {
                sex = option
            }
        } label: {
            Text(option.title)
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(isSelected ? NutriColors.surface : NutriColors.textMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? NutriColors.olive : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var metricsSection: some View {
        VStack(spacing: 14) {
            numberField("Age", value: $age, unit: "years")

            if profile.unitSystem == .metric {
                numberField("Height", value: $heightCentimeters, unit: "cm")
                numberField("Weight", value: $weightValue, unit: "kg")
            } else {
                HStack(spacing: 12) {
                    numberField("Feet", value: $heightFeet, unit: "ft")
                    numberField("Inches", value: $heightInches, unit: "in")
                }

                numberField("Weight", value: $weightValue, unit: "lb")
            }
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
                .frame(width: 78)

            Text(unit)
                .font(NutriTypography.caption)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private func numberField(_ title: String, value: Binding<Int>, unit: String) -> some View {
        HStack {
            Text(title)
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(NutriColors.text)

            Spacer()

            TextField(title, value: value, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.text)
                .tint(NutriColors.olive)
                .frame(width: 58)

            Text(unit)
                .font(NutriTypography.caption)
                .foregroundStyle(NutriColors.textMuted)
        }
    }

    private func save() {
        profile.sex = sex
        profile.age = max(1, age)

        if profile.unitSystem == .metric {
            profile.heightCentimeters = max(1, heightCentimeters)
            profile.weightKilograms = max(1, weightValue)
        } else {
            profile.heightCentimeters = max(1, ProfileMeasurementFormatter.centimeters(feet: heightFeet, inches: heightInches))
            profile.weightKilograms = max(1, ProfileMeasurementFormatter.kilograms(fromPounds: weightValue))
        }

        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    EditBodyProfileSheet(profile: UserProfile())
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
