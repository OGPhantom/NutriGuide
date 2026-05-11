import SwiftUI

struct NutriProgressBar: View {
    let value: Double
    let goal: Double
    var tint: Color = NutriColors.olive
    var height: CGFloat = 7

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(max(value / goal, 0), 1)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(NutriColors.divider.opacity(0.65))

                Capsule()
                    .fill(tint)
                    .frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: height)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}

#Preview {
    NutriProgressBar(value: 1_240, goal: 2_100)
        .padding()
        .background(NutriColors.cream)
}
