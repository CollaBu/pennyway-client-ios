
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
            } else {
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
                .frame(height: 4 * DynamicSizeFactor.factor())

            if isCurrentMonthDay {
                if let dailyTotalAmount = SpendingHistoryUtil.getSpendingAmount(for: day, from: spendingHistoryViewModel) {
                    VStack(spacing: -3) { // 텍스트 높이 조정
                        ForEach(SpendingHistoryUtil.truncatedText("\(dailyTotalAmount)").split(separator: "\n"), id: \.self) { line in
                            Text(line)
                                .font(.B4MediumFont())
                                .platformTextColor(color: isToday ? Color("Mint03") : Color("Gray07"))
                        }
                    }
                    .frame(width: 36 * DynamicSizeFactor.factor(), height: 12 * DynamicSizeFactor.factor())

                } else {
                    Spacer()
                        .frame(height: 12 * DynamicSizeFactor.factor())
                }
            }
        }
        .frame(height: 34 * DynamicSizeFactor.factor())
        .edgesIgnoringSafeArea(.all)
    }

    private func isSpendingDay(_ day: Int) -> Bool {
        return spendingHistoryViewModel.dailySpendings.contains { $0.day == day }
    }
}
