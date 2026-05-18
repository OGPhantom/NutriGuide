import Foundation

enum ProfileSheetDestination: String, Identifiable {
    case identity
    case bodyProfile
    case activityGoal
    case dailyTargets

    nonisolated var id: String { rawValue }
}
