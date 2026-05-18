import SwiftData
import SwiftUI

struct EditIdentitySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var displayName: String

    init(profile: UserProfile) {
        self.profile = profile
        _displayName = State(initialValue: profile.displayName)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Name")
                        .font(NutriTypography.cardTitle)
                        .foregroundStyle(NutriColors.text)

                    TextField("Name", text: $displayName)
                        .font(NutriTypography.body)
                        .foregroundStyle(NutriColors.text)
                        .tint(NutriColors.olive)
                        .padding(14)
                        .background(NutriColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(NutriColors.divider.opacity(0.7), lineWidth: 1)
                        )
                }
                .nutriSurfaceCard()
                .padding(20)
            }
            .background(NutriColors.cream.ignoresSafeArea())
            .navigationTitle("Edit profile")
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

    private func save() {
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.displayName = trimmedName.isEmpty ? "Bohdan" : trimmedName
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    EditIdentitySheet(profile: UserProfile())
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: false))
}
