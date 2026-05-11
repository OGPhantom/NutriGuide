import SwiftUI

struct NutriToast: Identifiable, Equatable {
    let id = UUID()
    var message: String
    var systemImage: String
}

struct NutriToastView: View {
    let toast: NutriToast

    var body: some View {
        Label(toast.message, systemImage: toast.systemImage)
            .font(NutriTypography.bodySemibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 13)
            .background(NutriColors.oliveDark.opacity(0.94))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.16), radius: 18, x: 0, y: 10)
            .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    NutriToastView(toast: NutriToast(message: "Meal saved", systemImage: "checkmark.circle.fill"))
        .padding()
        .background(NutriColors.cream)
}
