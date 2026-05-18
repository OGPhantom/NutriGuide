import SwiftUI

struct InsightHeroCard: View {
    let insight: CoachInsight?
    let request: CoachInsightRequest
    let availability: CoachInsightClientAvailability
    let phase: InsightsGenerationPhase
    let onGenerate: () -> Void

    @State private var showsSummary = false

    private var hasInsight: Bool {
        insight != nil
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            InsightAIMarkView()
                .padding(.trailing, -8)
                .padding(.top, -8)

            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(headline)
                        .font(.system(size: 30, weight: .regular, design: .serif))
                        .foregroundStyle(NutriColors.oliveDark)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 236, alignment: .leading)
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: showSummary)

                footer
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .nutriSurfaceCard(cornerRadius: 28, padding: 24)
        .sheet(isPresented: $showsSummary) {
            InsightSummarySheet(
                title: headline,
                summary: summary,
                generatedAt: insight?.createdAt,
                periodStart: insight?.periodStart ?? request.periodStart,
                periodEnd: insight?.periodEnd ?? request.periodEnd
            )
//            .presentationDetents([.height(340), .medium])
            .presentationDragIndicator(.visible)
            .presentationBackground(NutriColors.surface)
        }
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private var footer: some View {
        switch phase {
        case .generating:
            HStack(spacing: 10) {
                ProgressView()
                    .tint(NutriColors.olive)

                Text("Generating insight")
                    .font(NutriTypography.captionSemibold)
                    .foregroundStyle(NutriColors.textMuted)
            }
            .padding(.top, 2)
        case .failed:
            HStack(spacing: 12) {
                quietMessage("We couldn’t generate your insight")

                if canGenerate {
                    Button("Try again", action: onGenerate)
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(NutriColors.apricot)
                }
            }
        case .idle:
            if canGenerate {
                Button(action: onGenerate) {
                    Label(hasInsight ? "Refresh insight" : "Generate insight", systemImage: "sparkles")
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(NutriColors.surface)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(NutriColors.olive)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            } else {
                quietMessage(footerMessage)
            }
        }
    }

    private var headline: String {
        switch phase {
        case .generating:
            return "Analyzing your recent meals"
        case .failed where insight == nil:
            return "Insight needs another try"
        default:
            if let insight {
                return insight.headline
            }

            if !request.isEligible {
                return "Log a little more food"
            }

            if availability == .unavailable {
                return "AI Coach is unavailable on this device"
            }

            return "Ready for your AI Coach Summary"
        }
    }

    private var summary: String {
        switch phase {
        case .generating:
            return "Reviewing your calories, macro balance, goals, and recent meal rhythm."
        case .failed(let message) where insight == nil:
            return message
        default:
            if let insight {
                return insight.summary
            }

            if !request.isEligible {
                return "AI Coach needs at least 3 meals across 2 different days from the last 7 calendar days."
            }

            if availability == .unavailable {
                return "Try again on a device that supports Apple Intelligence."
            }

            return "Generate a calm, personalized read on your recent nutrition and what to improve next."
        }
    }

    private var canGenerate: Bool {
        request.isEligible && availability == .available
    }

    private var footerMessage: String {
        if !request.isEligible {
            return hasInsight ? "Log more meals to refresh" : "Needs more meal history"
        }

        if availability == .unavailable {
            return "Apple Intelligence unavailable"
        }

        return ""
    }

    private func quietMessage(_ message: String) -> some View {
        Text(message)
            .font(NutriTypography.captionSemibold)
            .foregroundStyle(NutriColors.textMuted)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(NutriColors.oliveSoft.opacity(0.58))
            .clipShape(Capsule())
    }

    private func showSummary() {
        guard phase != .generating else {
            return
        }

        showsSummary = true
    }
}

#Preview {
    let request = PreviewFixtures.insightRequest(isEligible: true)

    InsightHeroCard(
        insight: PreviewFixtures.coachInsight,
        request: request,
        availability: .available,
        phase: .idle,
        onGenerate: {}
    )
    .padding()
    .background(NutriColors.cream)
}
