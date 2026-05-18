import Foundation
import SwiftData

@MainActor
@Observable
final class ProfileViewModel {
    var presentedSheet: ProfileSheetDestination?

    func showIdentityEditor() {
        presentedSheet = .identity
    }

    func showBodyProfileEditor() {
        presentedSheet = .bodyProfile
    }

    func showActivityGoalEditor() {
        presentedSheet = .activityGoal
    }

    func showDailyTargetsEditor() {
        presentedSheet = .dailyTargets
    }

    func seedDefaultProfileIfNeeded(in modelContext: ModelContext) {
        try? ProfileSeedService.seedDefaultProfileIfNeeded(in: modelContext)
    }
}
