import SwiftUI

struct ScanHeroCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(NutriColors.surface)
                        .frame(width: 66, height: 66)
                        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 7)

                    Image(systemName: "camera")
                        .font(.system(.title2, design: .rounded).weight(.medium))
                        .foregroundStyle(NutriColors.olive)
                }

                VStack(alignment: .leading, spacing: 7) {
                    Text("Scan your meal")
                        .font(NutriTypography.heroTitle)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)

                    Text("Calories and macros in seconds.")
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                PremiumFoodRenderView()
                    .offset(x: 18)
            }
            .padding(.leading, 18)
            .padding(.vertical, 18)
            .padding(.trailing, 0)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(
                LinearGradient(
                    colors: [NutriColors.olive, NutriColors.oliveDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: NutriColors.oliveDark.opacity(0.18), radius: 18, x: 0, y: 12)
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Scan your meal")
    }
}

#Preview {
    ScanHeroCard {}
        .padding()
        .background(NutriColors.cream)
}
