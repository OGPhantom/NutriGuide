import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Privacy")
                    .font(NutriTypography.screenTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                VStack(alignment: .leading, spacing: 16) {
                    privacyRow(
                        title: "Photos are not saved",
                        body: "Meal photos are used during analysis and review only. Saved meal history stores nutrition data, not the original image."
                    )

                    divider

                    privacyRow(
                        title: "Local meal history",
                        body: "Meals, ingredients, profile values, and targets are stored locally with SwiftData on this device."
                    )

                    divider

                    privacyRow(
                        title: "AI analysis",
                        body: "Photos selected for analysis are sent to the configured AI service to estimate calories, macros, and ingredients."
                    )
                }
                .nutriSurfaceCard()
            }
            .padding(.horizontal, 20)
            .padding(.top, 26)
            .padding(.bottom, 48)
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Privacy")
        .tint(NutriColors.olive)
    }

    private func privacyRow(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(NutriColors.text)

            Text(body)
                .font(NutriTypography.body)
                .foregroundStyle(NutriColors.textMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(NutriColors.divider.opacity(0.85))
            .frame(height: 1)
    }
}

#Preview {
    NavigationStack {
        PrivacyView()
    }
}
