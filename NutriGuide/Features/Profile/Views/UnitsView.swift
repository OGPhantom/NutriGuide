import SwiftData
import SwiftUI

struct UnitsView: View {
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Units")
                    .font(NutriTypography.screenTitle)
                    .foregroundStyle(NutriColors.oliveDark)

                VStack(spacing: 0) {
                    ForEach(UnitSystem.allCases) { unitSystem in
                        Button {
                            select(unitSystem)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(unitSystem.title)
                                        .font(NutriTypography.bodySemibold)
                                        .foregroundStyle(NutriColors.text)

                                    Text(unitSystem.detail)
                                        .font(NutriTypography.caption)
                                        .foregroundStyle(NutriColors.textMuted)
                                }

                                Spacer()

                                if profile.unitSystem == unitSystem {
                                    Image(systemName: "checkmark")
                                        .font(.system(.caption, design: .rounded).weight(.bold))
                                        .foregroundStyle(NutriColors.olive)
                                }
                            }
                            .padding(.vertical, 15)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if unitSystem != UnitSystem.allCases.last {
                            Rectangle()
                                .fill(NutriColors.divider.opacity(0.85))
                                .frame(height: 1)

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
        .navigationTitle("Units")
        .tint(NutriColors.olive)
    }

    private func select(_ unitSystem: UnitSystem) {
        profile.unitSystem = unitSystem
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        UnitsView(profile: UserProfile())
    }
    .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
