import Foundation

extension Double {
    var kcalText: String {
        formatted(.number.precision(.fractionLength(0))) + " kcal"
    }

    var gramsText: String {
        formatted(.number.precision(.fractionLength(0))) + " g"
    }

    var portionText: String {
        formatted(.number.precision(.fractionLength(amountFractionLength))) 
    }

    private var amountFractionLength: Int {
        rounded() == self ? 0 : 1
    }
}
