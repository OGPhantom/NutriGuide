import SwiftUI

struct SurfaceCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 28
    var padding: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(NutriColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: NutriColors.oliveDark.opacity(0.06), radius: 18, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(NutriColors.divider.opacity(0.55), lineWidth: 1)
            )
    }
}

extension View {
    func nutriSurfaceCard(cornerRadius: CGFloat = 28, padding: CGFloat = 20) -> some View {
        modifier(SurfaceCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
}
