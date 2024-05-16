
import SwiftUI

// MARK: - SpendingCalendarCellView

struct SpendingCalendarCellView: View {
    var date: Date
    var day: Int
    var clicked: Bool
    var isToday: Bool
    var isCurrentMonthDay: Bool

    private var textColor: Color {
        if clicked {
            return Color("White01")
        } else if isCurrentMonthDay {
            if isToday {
                return Color("Mint03")
            } else if isSpendingDay(day) {
                return Color("Gray06")
            } else {
                return Color("Gray03")
            }
        } else {
            return Color("White01")
        }
    }

    private var backgroundColor: Color {
        if clicked {
            Log.debug(date)
            return Color("Gray07")
        } else if isToday {
            return Color("Mint01")
        } else {
            return Color("White01")
        }
    }

    init(
        date: Date,
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.date = date
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
    }

    var body: some View {
        VStack {
            Circle()
                .fill(backgroundColor)
                .overlay(
                    Text(String(day))
                        .font(.B2MediumFont())
                )
                .platformTextColor(color: textColor)
                .frame(width: 22 * DynamicSizeFactor.factor(), height: 22 * DynamicSizeFactor.factor())

            Spacer()
                .frame(height: 1 * DynamicSizeFactor.factor())

            if isSpendingDay(day) {
                Text("-10,000")
                    .font(.B4MediumFont())
                    .platformTextColor(color: isToday ? Color("Mint03") : Color("Gray07"))
                    .frame(height: 10 * DynamicSizeFactor.factor())
            } else {
                Spacer()
                    .frame(height: 10 * DynamicSizeFactor.factor())
            }
        }
        .frame(height: 32 * DynamicSizeFactor.factor())
    }

    private func isSpendingDay(_ day: Int) -> Bool {
        // TODO: month,day,money를 합친 model 생성 필요
        var month: Int {
            let calendar = Calendar.current
            return calendar.component(.month, from: date)
        }
        let specialDays = [8, 13, 15]
        if month == 5 {
            return specialDays.contains(day)
        } else if month == 4 {
            return specialDays.contains(day)
        } else {
            return false
        }
    }
}