import SwiftUI

enum NutriTypography {
    static let screenTitle = Font.system(.largeTitle, design: .serif).weight(.regular)
    static let heroTitle = Font.system(.title, design: .serif).weight(.regular)
    static let cardTitle = Font.system(.title3, design: .serif).weight(.semibold)
    static let mealTitle = Font.system(.headline, design: .serif).weight(.semibold)
    static let largeNumber = Font.system(.largeTitle, design: .serif).weight(.regular)
    static let body = Font.system(.body, design: .rounded)
    static let bodySemibold = Font.system(.body, design: .rounded).weight(.semibold)
    static let caption = Font.system(.caption, design: .rounded)
    static let captionSemibold = Font.system(.caption, design: .rounded).weight(.semibold)
}
