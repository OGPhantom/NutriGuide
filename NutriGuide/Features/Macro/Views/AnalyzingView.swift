import SwiftUI

struct AnalyzingView: View {
    let photo: CapturedMealPhoto
    let client: OpenAIFoodAnalysisClient
    let onGoHome: () -> Void
    let onAnalysisComplete: (FoodAnalysisDraft) -> Void

    @State private var phase: Phase = .loading

    var body: some View {
        ZStack {
            NutriColors.cream.ignoresSafeArea()

            switch phase {
            case .loading:
                loadingState
            case .failed:
                failedState
            }
        }
        .task(id: photo.id) {
            guard !Self.isRunningInPreview else { return }
            await analyze()
        }
    }

    private var loadingState: some View {
        VStack(spacing: 28) {
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
                    .clipped()
                    .shadow(color: NutriColors.oliveDark.opacity(0.12), radius: 24, x: 0, y: 16)
            } else {
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(NutriColors.surface)
                    .frame(width: 260, height: 260)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(NutriColors.olive)
                    }
            }

            ProgressView()
                .tint(NutriColors.olive)

            Text("Analyzing your meal")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)
        }
        .padding(32)
    }

    private var failedState: some View {
        VStack(spacing: 22) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 42, weight: .regular, design: .rounded))
                .foregroundStyle(NutriColors.danger)

            Text("We couldn’t analyze this meal")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                NutriPrimaryButton(title: "Try again", systemImage: "arrow.clockwise") {
                    Task { await analyze() }
                }

                Button("Go home", action: onGoHome)
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(NutriColors.olive)
                    .padding(.vertical, 10)
            }
            .padding(.top, 8)
        }
        .padding(32)
    }

    private func analyze() async {
        phase = .loading

        do {
            let analysis = try await client.analyzeFoodImage(photo.data)
            try Task.checkCancellation()
            onAnalysisComplete(analysis)
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            phase = .failed
        }
    }

    private enum Phase {
        case loading
        case failed
    }

    private static var isRunningInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

#Preview("Analyzing") {
    AnalyzingView(
        photo: CapturedMealPhoto(data: Data()),
        client: OpenAIFoodAnalysisClient(apiKey: "preview"),
        onGoHome: {},
        onAnalysisComplete: { _ in }
    )
}
