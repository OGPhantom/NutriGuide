import Foundation

enum ProfileMeasurementFormatter {
    static func heightText(centimeters: Double, unitSystem: UnitSystem) -> String {
        switch unitSystem {
        case .metric:
            return "\(centimeters.formatted(.number.precision(.fractionLength(0)))) cm"
        case .imperial:
            let totalInches = max(0, Int((centimeters / 2.54).rounded()))
            let feet = totalInches / 12
            let inches = totalInches % 12
            return "\(feet) ft \(inches) in"
        }
    }

    static func weightText(kilograms: Double, unitSystem: UnitSystem) -> String {
        switch unitSystem {
        case .metric:
            return "\(kilograms.formatted(.number.precision(.fractionLength(0)))) kg"
        case .imperial:
            return "\(pounds(fromKilograms: kilograms).formatted(.number.precision(.fractionLength(0)))) lb"
        }
    }

    static func pounds(fromKilograms kilograms: Double) -> Double {
        kilograms * 2.20462
    }

    static func kilograms(fromPounds pounds: Double) -> Double {
        pounds / 2.20462
    }

    static func totalInches(fromCentimeters centimeters: Double) -> Int {
        max(0, Int((centimeters / 2.54).rounded()))
    }

    static func centimeters(feet: Int, inches: Int) -> Double {
        Double(max(0, feet) * 12 + max(0, inches)) * 2.54
    }
}
