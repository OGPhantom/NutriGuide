import SwiftUI

struct ProfileHeroCard: View {
    let profile: UserProfile
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .trailing) {
                wellnessAccent
                    .offset(x: 18, y: 2)

                VStack(alignment: .leading, spacing: 14) {
                    Text("Nutrition profile")
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(.white.opacity(0.74))

                    Text(profile.displayName)
                        .font(.system(size: 48, weight: .regular, design: .serif))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.74)
                        .frame(maxWidth: 230, alignment: .leading)

                    HStack(spacing: 8) {
                        Text(profile.goal.title)
                            .font(NutriTypography.captionSemibold)
                            .foregroundStyle(NutriColors.oliveDark)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(NutriColors.surface.opacity(0.92))
                            .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(22)
            .background(
                LinearGradient(
                    colors: [NutriColors.olive, NutriColors.oliveDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: NutriColors.oliveDark.opacity(0.16), radius: 20, x: 0, y: 14)
            .contentShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit profile identity")
    }

    private var wellnessAccent: some View {
        ZStack {
            Circle()
                .fill(NutriColors.surface.opacity(0.12))
                .frame(width: 118, height: 118)

//            Circle()
//                .stroke(NutriColors.surface.opacity(0.18), lineWidth: 1.2)
//                .frame(width: 92, height: 92)

            Circle()
                .fill(NutriColors.apricot.opacity(0.22))
                .frame(width: 56, height: 56)
                .offset(x: 22, y: -22)

            Circle()
                .fill(NutriColors.surface.opacity(0.16))
                .frame(width: 34, height: 34)
                .offset(x: -30, y: 28)

            Image(systemName: "leaf.fill")
                .font(.system(size: 54, weight: .medium))
                .foregroundStyle(NutriColors.surface.opacity(0.92))
                .rotationEffect(.degrees(-22))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)

            Image(systemName: "sparkle")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(NutriColors.apricot.opacity(0.86))
                .offset(x: 36, y: -36)
        }
        .frame(width: 126, height: 126)
        .accessibilityHidden(true)
    }
}

#Preview {
    ProfileHeroCard(profile: UserProfile()) {}
        .padding()
        .background(NutriColors.cream)
}
