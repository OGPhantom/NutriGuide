import SwiftUI

struct DiaryCalendarCard: View {
    let monthTitle: String
    let days: [DiaryCalendarDay]
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onSelectDay: (DiaryCalendarDay) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Previous month", systemImage: "chevron.left", action: onPreviousMonth)
                    .labelStyle(.iconOnly)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(NutriColors.textMuted)
                    .frame(width: 38, height: 38)

                Spacer()

                Text(monthTitle)
                    .font(NutriTypography.cardTitle)
                    .foregroundStyle(NutriColors.text)

                Spacer()

                Button("Next month", systemImage: "chevron.right", action: onNextMonth)
                    .labelStyle(.iconOnly)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(NutriColors.textMuted)
                    .frame(width: 38, height: 38)
            }
            .buttonStyle(.plain)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(NutriColors.textMuted)
                        .frame(maxWidth: .infinity)
                }

                ForEach(days) { day in
                    dayCell(day)
                }
            }
        }
        .nutriSurfaceCard(cornerRadius: 28, padding: 16)
    }

    private func dayCell(_ day: DiaryCalendarDay) -> some View {
        Button {
            withAnimation(.snappy(duration: 0.2)) {
                onSelectDay(day)
            }
        } label: {
            VStack(spacing: 3) {
                ZStack {
                    if day.isSelected {
                        Circle()
                            .fill(NutriColors.olive)
                            .frame(width: 34, height: 34)
                    } else if day.isToday {
                        Circle()
                            .stroke(NutriColors.olive.opacity(0.75), lineWidth: 1.2)
                            .frame(width: 34, height: 34)
                    }

                    Text("\(day.dayNumber)")
                        .font(.system(.callout, design: .rounded).weight(.semibold))
                        .foregroundStyle(dayNumberColor(for: day))
                }
                .frame(height: 34)

                Circle()
                    .fill(day.hasMeals && !day.isSelected ? NutriColors.olive : .clear)
                    .frame(width: 4, height: 4)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(day.date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
        .accessibilityAddTraits(day.isSelected ? .isSelected : [])
    }

    private func dayNumberColor(for day: DiaryCalendarDay) -> Color {
        if day.isSelected {
            return .white
        }

        if day.isInDisplayedMonth {
            return NutriColors.text
        }

        return NutriColors.textMuted.opacity(0.45)
    }
}

#Preview {
    DiaryCalendarCard(
        monthTitle: "May 2026",
        days: DiaryViewModel().calendarDays(from: PreviewFixtures.meals),
        onPreviousMonth: {},
        onNextMonth: {},
        onSelectDay: { _ in }
    )
    .padding()
    .background(NutriColors.cream)
}
