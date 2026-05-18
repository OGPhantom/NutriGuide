import SwiftUI

extension MealType {
    var foodSymbol: String {
        switch self {
        case .breakfast:
            "cup.and.saucer"
        case .lunch:
            "fork.knife"
        case .dinner:
            "takeoutbag.and.cup.and.straw"
        case .snacks:
            "popcorn"
        }
    }

    var iconBackground: Color {
        switch self {
        case .breakfast:
            Color(hex: 0xFFF3C7) // soft saffron
        case .lunch:
            Color(hex: 0xDFF3EA) // soft mint
        case .dinner:
            Color(hex: 0xE7E0F4) // soft lavender
        case .snacks:
            Color(hex: 0xFFE0D6) // soft coral
        }
    }

    var iconForeground: Color {
        switch self {
        case .breakfast:
            Color(hex: 0xD18A00) // saffron
        case .lunch:
            Color(hex: 0x168A68) // mint green
        case .dinner:
            Color(hex: 0x7057B8) // lavender
        case .snacks:
            Color(hex: 0xD95738) // coral
        }
    }
}
