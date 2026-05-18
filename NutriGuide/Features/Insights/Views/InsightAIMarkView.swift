import SwiftUI

struct InsightAIMarkView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(NutriColors.apricotSoft.opacity(0.82))
                .frame(width: 142, height: 142)
                .offset(x: 34, y: -12)

            Circle()
                .fill(NutriColors.apricot.opacity(0.28))
                .frame(width: 104, height: 104)
                .offset(x: 74, y: 36)

            Circle()
                .stroke(NutriColors.surface.opacity(0.95), lineWidth: 12)
                .frame(width: 94, height: 94)
                .offset(x: 46, y: 24)

            Image(systemName: "sparkles")
                .font(.system(size: 34, weight: .medium))
                .foregroundStyle(NutriColors.olive)
                .offset(x: 42, y: 16)

            Image(systemName: "leaf.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(NutriColors.apricot)
                .offset(x: 74, y: -14)
        }
        .frame(width: 172, height: 154)
        .accessibilityHidden(true)
    }
}

#Preview {
    InsightAIMarkView()
        .padding()
        .background(NutriColors.cream)
}
