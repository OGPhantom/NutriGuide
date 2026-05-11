import SwiftUI

struct EditableValueHeader: View {
    let title: String
    let value: String
    var showsEdit = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(NutriColors.textMuted)

                    Text(value)
                        .font(NutriTypography.cardTitle)
                        .foregroundStyle(NutriColors.text)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                if showsEdit {
                    Image(systemName: "pencil")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(NutriColors.olive)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
