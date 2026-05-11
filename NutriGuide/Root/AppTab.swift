import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case diary
    case insights
    case me

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            "Home"
        case .diary:
            "Diary"
        case .insights:
            "Insights"
        case .me:
            "Me"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            "house.fill"
        case .diary:
            "calendar"
        case .insights:
            "chart.bar"
        case .me:
            "person"
        }
    }

    @ViewBuilder
    var content: some View {
        switch self {
        case .home:
            HomeView()
        case .diary, .insights, .me:
            PlaceholderTabView(title: title)
        }
    }
}
