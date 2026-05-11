import SwiftUI

struct PlaceholderTabView: View {
    let title: String

    var body: some View {
        ZStack {
            NutriColors.cream.ignoresSafeArea()

            Text(title)
                .font(NutriTypography.screenTitle)
                .foregroundStyle(NutriColors.oliveDark.opacity(0.35))
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    PlaceholderTabView(title: "Diary")
}
