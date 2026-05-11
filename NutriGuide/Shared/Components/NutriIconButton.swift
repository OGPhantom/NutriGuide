import SwiftUI

struct NutriIconButton: View {
    let title: String
    let systemImage: String
    var size: CGFloat = 46
    var foreground: Color = .white
    var background: Color = NutriColors.cameraControl
    let action: () -> Void

    var body: some View {
        Button(title, systemImage: systemImage, action: action)
            .font(.system(.body, design: .rounded).weight(.semibold))
            .labelStyle(.iconOnly)
            .foregroundStyle(foreground)
            .frame(width: size, height: size)
            .background(background)
            .clipShape(Circle())
            .buttonStyle(.plain)
            .accessibilityLabel(title)
    }
}

#Preview {
    HStack {
        NutriIconButton(title: "Close", systemImage: "xmark") {}
        NutriIconButton(title: "Choose from Library", systemImage: "photo") {}
    }
    .padding()
    .background(.black)
}
