import SwiftUI

struct MacroBalanceDonutChart: View {
    let protein: Double
    let fat: Double
    let carbs: Double

    private var total: Double {
        protein + fat + carbs
    }

    private var slices: [(value: Double, color: Color)] {
        [
            (protein, NutriColors.protein),
            (fat, NutriColors.fat),
            (carbs, NutriColors.carbs)
        ]
    }

    var body: some View {
        Canvas { context, size in
            let lineWidth: CGFloat = 18
            let inset = lineWidth / 2
            let radius = min(size.width, size.height) / 2 - inset
            let center = CGPoint(x: size.width / 2, y: size.height / 2)

            var backgroundPath = Path()
            backgroundPath.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(0),
                endAngle: .degrees(360),
                clockwise: false
            )

            context.stroke(
                backgroundPath,
                with: .color(NutriColors.divider.opacity(0.62)),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
            )

            guard total > 0 else {
                return
            }

            var startAngle = Angle.degrees(-90)

            for slice in slices where slice.value > 0 {
                let angle = Angle.degrees((slice.value / total) * 360)
                let endAngle = startAngle + angle
                var path = Path()
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )

                context.stroke(
                    path,
                    with: .color(slice.color),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
                )

                startAngle = endAngle
            }
        }
        .accessibilityLabel("Average macro ratio")
    }
}

#Preview {
    MacroBalanceDonutChart(protein: 72, fat: 58, carbs: 186)
        .frame(width: 132, height: 132)
        .padding()
        .background(NutriColors.cream)
}
