import SwiftUI

struct InsightSummarySheet: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let summary: String
    let generatedAt: Date?
    let periodStart: Date
    let periodEnd: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(alignment: .center) {
                Text("AI Coach Summary")
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.text)

                Spacer()

                Button("Close", systemImage: "xmark", action: dismiss.callAsFunction)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .labelStyle(.iconOnly)
                    .foregroundStyle(NutriColors.olive)
                    .frame(width: 42, height: 42)
                    .background(NutriColors.oliveSoft.opacity(0.72))
                    .clipShape(Circle())
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close summary")
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 34, weight: .regular, design: .serif))
                    .foregroundStyle(NutriColors.oliveDark)
                    .lineSpacing(1)
                    .fixedSize(horizontal: false, vertical: true)

                Text(summary)
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.textMuted)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(NutriColors.apricot)

                Text(metadataText)
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 22)
        .padding(.bottom, 18)
        .background(NutriColors.surface)
    }

    private var metadataText: String {
        let period = "\(periodStart.formatted(.dateTime.month(.abbreviated).day())) - \(periodEnd.formatted(.dateTime.month(.abbreviated).day()))"

        if let generatedAt {
            return "Generated \(generatedAt.metadataDayText()) · \(period)"
        }

        return period
    }
}

#Preview {
    InsightSummarySheet(
        title: "Your week is leaning light on protein",
        summary: "Your meals show a steady calorie rhythm, but protein is doing most of its work later in the day. A little more protein earlier can support energy and fullness.",
        generatedAt: .now,
        periodStart: Calendar.current.date(byAdding: .day, value: -6, to: .now) ?? .now,
        periodEnd: .now
    )
    .background(NutriColors.cream)
}
