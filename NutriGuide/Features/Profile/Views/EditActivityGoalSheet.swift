import SwiftData
import SwiftUI

struct EditActivityGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var activityLevel: ActivityLevel
    @State private var goal: NutritionGoal

    init(profile: UserProfile) {
        self.profile = profile
        _activityLevel = State(initialValue: profile.activityLevel)
        _goal = State(initialValue: profile.goal)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    selectionSection("Activity", options: ActivityLevel.allCases, selection: $activityLevel)
                    selectionSection("Goal", options: NutritionGoal.allCases, selection: $goal)
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(NutriColors.cream.ignoresSafeArea())
            .navigationTitle("Activity & Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(NutriColors.cream, for: .navigationBar)
            .tint(NutriColors.olive)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func selectionSection<Option: ProfileSelectableOption>(
        _ title: String,
        options: [Option],
        selection: Binding<Option>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            VStack(spacing: 0) {
                ForEach(options) { option in
                    Button {
                        selection.wrappedValue = option
                    } label: {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(option.title)
                                    .font(NutriTypography.bodySemibold)
                                    .foregroundStyle(NutriColors.text)

                                Text(option.detail)
                                    .font(NutriTypography.caption)
                                    .foregroundStyle(NutriColors.textMuted)
                            }

                            Spacer()

                            if selection.wrappedValue.id == option.id {
                                Image(systemName: "checkmark")
                                    .font(.system(.caption, design: .rounded).weight(.bold))
                                    .foregroundStyle(NutriColors.olive)
                            }
                        }
                        .padding(.vertical, 13)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if option.id != options.last?.id {
                        Rectangle()
                            .fill(NutriColors.divider.opacity(0.85))
                            .frame(height: 1)
                    }
                }
            }
        }
        .nutriSurfaceCard()
    }

    private func save() {
        profile.activityLevel = activityLevel
        profile.goal = goal
        try? modelContext.save()
        dismiss()
    }
}

private protocol ProfileSelectableOption: Identifiable, Hashable {
    var title: String { get }
    var detail: String { get }
}

extension ActivityLevel: ProfileSelectableOption {}
extension NutritionGoal: ProfileSelectableOption {}

#Preview {
    EditActivityGoalSheet(profile: UserProfile())
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
