import SwiftUI

struct EmptyRecentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(.title3, design: .rounded).weight(.medium))
                .foregroundStyle(NutriColors.olive)

            Text("Your latest meals will appear here after the first scan.")
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.textMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }
}

#Preview {
    EmptyRecentView()
        .padding()
        .background(NutriColors.surface)
}
