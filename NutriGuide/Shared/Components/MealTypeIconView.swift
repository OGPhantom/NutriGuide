import SwiftUI

struct MealTypeIconView: View {
    let mealType: MealType
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: mealType.foodSymbol)
            .font(.system(size: size * 0.42, weight: .semibold, design: .rounded))
            .foregroundStyle(mealType.iconForeground)
            .frame(width: size, height: size)
            .background(mealType.iconBackground)
            .clipShape(Circle())
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack {
        ForEach(MealType.allCases) { type in
            MealTypeIconView(mealType: type)
        }
    }
    .padding()
    .background(NutriColors.cream)
}
