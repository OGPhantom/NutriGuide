import SwiftUI

struct BodyProfileCard: View {
    let profile: UserProfile
    let action: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Body Profile")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                LazyVGrid(columns: columns, spacing: 12) {
                    tile(title: "Sex", value: profile.sex.title)
                    tile(title: "Age", value: "\(profile.age)")
                    tile(
                        title: "Height",
                        value: ProfileMeasurementFormatter.heightText(
                            centimeters: profile.heightCentimeters,
                            unitSystem: profile.unitSystem
                        )
                    )
                    tile(
                        title: "Weight",
                        value: ProfileMeasurementFormatter.weightText(
                            kilograms: profile.weightKilograms,
                            unitSystem: profile.unitSystem
                        )
                    )
                }
            }
            .nutriSurfaceCard()
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit body profile")
    }

    private func tile(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(value)
                .font(.system(.title3, design: .serif).weight(.regular))
                .foregroundStyle(NutriColors.oliveDark)
                .lineLimit(1)
                .minimumScaleFactor(0.74)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 6)
        .background(NutriColors.elevatedSurface.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    BodyProfileCard(profile: UserProfile()) {}
        .padding()
        .background(NutriColors.cream)
}
