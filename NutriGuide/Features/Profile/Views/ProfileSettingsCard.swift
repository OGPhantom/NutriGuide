import SwiftUI

struct ProfileSettingsCard: View {
    let profile: UserProfile

    var body: some View {
        VStack(spacing: 0) {
            NavigationLink {
                UnitsView(profile: profile)
            } label: {
                settingsRow(title: "Units", value: profile.unitSystem.displayTitle, systemImage: "ruler")
            }

            divider

            NavigationLink {
                PrivacyView()
            } label: {
                settingsRow(title: "Privacy", value: nil, systemImage: "shield")
            }

            divider

            NavigationLink {
                AppInfoView()
            } label: {
                settingsRow(title: "App info", value: nil, systemImage: "info.circle")
            }
        }
        .nutriSurfaceCard(cornerRadius: 28, padding: 0)
    }

    private func settingsRow(title: String, value: String?, systemImage: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(.body, design: .rounded).weight(.medium))
                .foregroundStyle(NutriColors.oliveDark)
                .frame(width: 24)

            Text(title)
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(NutriColors.text)

            Spacer()

            if let value {
                Text(value)
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.textMuted)
                    .lineLimit(1)
            }

            Image(systemName: "chevron.right")
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .foregroundStyle(NutriColors.textMuted.opacity(0.72))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 17)
        .contentShape(Rectangle())
    }

    private var divider: some View {
        Rectangle()
            .fill(NutriColors.divider.opacity(0.9))
            .frame(height: 1)
            .padding(.leading, 56)
    }
}

#Preview {
    NavigationStack {
        ProfileSettingsCard(profile: UserProfile())
            .padding()
            .background(NutriColors.cream)
    }
}
