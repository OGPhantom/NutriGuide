import SwiftUI
import SwiftData

struct AppInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var seedStatus: String?

    private var versionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String

        switch (version, build) {
        case (.some(let version), .some(let build)):
            return "Version \(version) (\(build))"
        case (.some(let version), .none):
            return "Version \(version)"
        default:
            return "Version 1.0"
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                Text("App info")
                    .font(NutriTypography.screenTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                VStack(alignment: .leading, spacing: 16) {
                    Text("NutriGuide")
                        .font(.system(size: 38, weight: .regular, design: .serif))
                        .foregroundStyle(NutriColors.oliveDark)

                    Text("AI-assisted nutrition tracking with photo analysis, meal history, and personalized profile-based targets.")
                        .font(NutriTypography.body)
                        .foregroundStyle(NutriColors.textMuted)
                        .fixedSize(horizontal: false, vertical: true)

                    Rectangle()
                        .fill(NutriColors.divider.opacity(0.85))
                        .frame(height: 1)

                    HStack {
                        Text("Build")
                            .font(NutriTypography.bodySemibold)
                            .foregroundStyle(NutriColors.text)

                        Spacer()

                        Text(versionText)
                            .font(NutriTypography.body)
                            .foregroundStyle(NutriColors.textMuted)
                    }

                    Rectangle()
                        .fill(NutriColors.divider.opacity(0.85))
                        .frame(height: 1)

                    VStack(alignment: .leading, spacing: 10) {
                        Button("Seed demo meals") {
                            seedDemoMeals()
                        }
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(NutriColors.apricot)
                        .buttonStyle(.plain)

                        if let seedStatus {
                            Text(seedStatus)
                                .font(NutriTypography.caption)
                                .foregroundStyle(NutriColors.textMuted)
                        }
                    }
                }
                .nutriSurfaceCard()
            }
            .padding(.horizontal, 20)
            .padding(.top, 26)
            .padding(.bottom, 48)
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("App info")
        .tint(NutriColors.olive)
    }

    private func seedDemoMeals() {
        do {
            try DemoMealSeedService.seedLast50Days(in: modelContext)
            seedStatus = "Demo meals added for the last 50 days."
        } catch {
            seedStatus = "Couldn’t seed demo meals."
        }
    }
}

#Preview {
    NavigationStack {
        AppInfoView()
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
