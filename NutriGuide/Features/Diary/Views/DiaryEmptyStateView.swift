import SwiftUI

struct DiaryEmptyStateView: View {
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundStyle(NutriColors.olive)
                .frame(width: 44, height: 44)
                .background(NutriColors.oliveSoft)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text("No meals logged")
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(NutriColors.text)

                Text("Meals you save for this day will appear here.")
                    .font(NutriTypography.caption)
                    .foregroundStyle(NutriColors.textMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .nutriSurfaceCard(cornerRadius: 24, padding: 18)
    }
}

#Preview {
    DiaryEmptyStateView()
        .padding()
        .background(NutriColors.cream)
}
