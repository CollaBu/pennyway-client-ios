
import SwiftUI

// MARK: - SpendingCalendarCellView

struct SpendingCalendarCellView: View {
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

    var date: Date
    var day: Int
    var clicked: Bool
    var isToday: Bool
    var isCurrentMonthDay: Bool

    private var textColor: Color {
        if clicked {
            return Color("Gray05")
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
            if isSpendingDay(day) {
                return Color("Gray03")
            }else{
                return Color("Gray02")
            }
        } else if isToday {
            return Color("Mint01")
        } else {
            return Color("White01")
        }
    }

    init(
        spendingHistoryViewModel: SpendingHistoryViewModel,
        date: Date,
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.spendingHistoryViewModel = spendingHistoryViewModel
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

            if isCurrentMonthDay {
                if let dailyTotalAmount = getSpendingAmount(for: day) {
                    Text("\(dailyTotalAmount)")
                        .font(.B4MediumFont())
                        .platformTextColor(color: isToday ? Color("Mint03") : Color("Gray07"))
                        .frame(height: 10 * DynamicSizeFactor.factor())
                } else {
                    Spacer()
                        .frame(height: 10 * DynamicSizeFactor.factor())
                }
            }
        }
        .frame(height: 32 * DynamicSizeFactor.factor())
    }

    private func isSpendingDay(_ day: Int) -> Bool {
        return spendingHistoryViewModel.dailySpendings.contains { $0.day == day }
    }

    private func getSpendingAmount(for day: Int) -> Int? {
        return spendingHistoryViewModel.dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }
}
