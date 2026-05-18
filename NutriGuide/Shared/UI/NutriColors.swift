import SwiftUI

enum NutriColors {
    static let cream = Color(hex: 0xF8F0E2)
    static let surface = Color(hex: 0xFFF9EF)
    static let elevatedSurface = Color(hex: 0xFFFCF5)

    static let olive = Color(hex: 0x52623B)
    static let oliveDark = Color(hex: 0x344026)
    static let oliveSoft = Color(hex: 0xE5E9D9)

    static let apricot = Color(hex: 0xEFAE79)
    static let apricotSoft = Color(hex: 0xFBE6D3)

    static let protein = Color(hex: 0x6A7A4A)
    static let fat = Color(hex: 0xF06A00)
    static let carbs = Color(hex: 0xF5A400)
    
    static let sand = Color(hex: 0xE9D9BE)
    static let text = Color(hex: 0x2C2A21)
    static let textMuted = Color(hex: 0x777064)
    static let divider = Color(hex: 0xE9DECC)
    static let danger = Color(hex: 0xC76547)
    static let cameraControl = Color.black.opacity(0.42)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
