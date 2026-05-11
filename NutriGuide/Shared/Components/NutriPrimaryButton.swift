import SwiftUI

struct NutriPrimaryButton: View {
    let title: String
    var systemImage: String?
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label {
                Text(title)
            } icon: {
                if let systemImage {
                    Image(systemName: systemImage)
                }
            }
            .font(NutriTypography.bodySemibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .foregroundStyle(.white)
            .background(isDisabled ? NutriColors.textMuted.opacity(0.35) : NutriColors.olive)
            .clipShape(Capsule())
        }
        .disabled(isDisabled)
        .buttonStyle(.plain)
    }
}

#Preview {
    NutriPrimaryButton(title: "Save", systemImage: "checkmark") {}
        .padding()
        .background(NutriColors.cream)
}
