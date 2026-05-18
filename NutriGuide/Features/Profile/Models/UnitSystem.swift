import Foundation

enum UnitSystem: String, CaseIterable, Codable, Identifiable {
    case metric
    case imperial

    nonisolated var id: String { rawValue }

    nonisolated var title: String {
        switch self {
        case .metric:
            "Metric"
        case .imperial:
            "Imperial"
        }
    }

    nonisolated var detail: String {
        switch self {
        case .metric:
            "kg, cm"
        case .imperial:
            "lb, ft"
        }
    }

    nonisolated var displayTitle: String {
        "\(title) (\(detail))"
    }
}
