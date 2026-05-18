import SwiftUI

struct ActivityGoalCard: View {
    let profile: UserProfile
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Activity & Goal")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                HStack(alignment: .top, spacing: 18) {
                    profileColumn(
                        title: "Activity",
                        value: profile.activityLevel.title,
                        detail: profile.activityLevel.preview
                    )

                    Rectangle()
                        .fill(NutriColors.divider)
                        .frame(width: 1)

                    profileColumn(
                        title: "Goal",
                        value: profile.goal.title,
                        detail: profile.goal.detail
                    )
                }
            }
            .nutriSurfaceCard()
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit activity and goal")
    }

    private func profileColumn(title: String, value: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.textMuted)

            Text(value)
                .font(NutriTypography.bodySemibold)
                .foregroundStyle(NutriColors.text)
                .lineLimit(1)
                .minimumScaleFactor(0.84)

            Text(detail)
                .font(NutriTypography.caption)
                .foregroundStyle(NutriColors.textMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.84)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ActivityGoalCard(profile: UserProfile()) {}
        .padding()
        .background(NutriColors.cream)
}
