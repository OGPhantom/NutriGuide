import SwiftUI

struct PremiumFoodRenderView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(NutriColors.surface)
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)

            Circle()
                .stroke(NutriColors.divider, lineWidth: 5)

            ingredientCircle(color: NutriColors.olive, size: 34, x: -20, y: -16)
            ingredientCircle(color: NutriColors.apricot, size: 20, x: 18, y: -18)
            ingredientCircle(color: Color(hex: 0xD79A4B), size: 16, x: 32, y: 6)
            ingredientCircle(color: Color(hex: 0x7FA56B), size: 18, x: -32, y: 14)

            Capsule()
                .fill(Color(hex: 0xF4D2A3))
                .frame(width: 58, height: 22)
                .rotationEffect(.degrees(-20))
                .overlay(
                    Capsule()
                        .stroke(Color(hex: 0xB98555).opacity(0.35), lineWidth: 1)
                )

            avocado
                .offset(x: 10, y: 22)
        }
        .frame(width: 118, height: 118)
        .accessibilityHidden(true)
    }

    private func ingredientCircle(color: Color, size: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(x: x, y: y)
    }

    private var avocado: some View {
        ZStack {
            Capsule()
                .fill(Color(hex: 0x9EBA72))
                .frame(width: 42, height: 24)
                .rotationEffect(.degrees(-28))

            Capsule()
                .fill(Color(hex: 0xE8D4A6))
                .frame(width: 30, height: 14)
                .rotationEffect(.degrees(-28))
        }
    }
}

#Preview {
    PremiumFoodRenderView()
        .padding()
        .background(NutriColors.olive)
}
