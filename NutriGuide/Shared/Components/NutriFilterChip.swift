import SwiftUI

struct NutriFilterChip: View {
    let title: String
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(NutriTypography.captionSemibold)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .foregroundStyle(isSelected ? .white : NutriColors.oliveDark)
                .background(isSelected ? NutriColors.olive : NutriColors.surface)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? .clear : NutriColors.divider, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        NutriFilterChip(title: "All", isSelected: true) {}
        NutriFilterChip(title: "Breakfast", isSelected: false) {}
    }
    .padding()
    .background(NutriColors.cream)
}
