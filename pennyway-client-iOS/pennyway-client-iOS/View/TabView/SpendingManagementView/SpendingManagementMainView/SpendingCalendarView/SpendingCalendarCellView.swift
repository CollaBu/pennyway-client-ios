
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
                        ForEach(truncatedText("\(dailyTotalAmount)").split(separator: "\n"), id: \.self) { line in
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

    private func truncatedText(_ text: String) -> String {
        let maxLength = 6
        let number = NumberFormatterUtil.formatStringToDecimalString(text)

        if number.count <= maxLength { // 1. 숫자 문자열의 길이가 최대 길이 이하인 경우 그대로 반환
            return "-\(number)\n "
        }

        // 2. 초기로 8자리만큼 문자열을 자름
        var truncatedNumber = number.prefix(8)
        // 3. 잘라낸 문자열에서 쉼표의 개수를 셈
        let commaCount = truncatedNumber.filter { $0 == "," }.count

        // 4. 쉼표의 개수에 따라 prefix 길이를 설정
        var prefixLength: Int
        switch commaCount {
        case 1:
            prefixLength = 7
        case 2:
            prefixLength = 8
        default:
            prefixLength = 7
        }

        // 5. 다시 숫자 문자열에서 prefix 길이만큼 자름
        truncatedNumber = number.prefix(prefixLength)

        // 6. 잘라낸 문자열이 쉼표로 끝나는 경우 쉼표를 제거
        if truncatedNumber.hasSuffix(",") {
            truncatedNumber = truncatedNumber.dropLast()
        }

        return "-\(truncatedNumber)\n..."
    }
}
