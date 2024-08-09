
import Foundation

class SpendingHistoryUtil {
    static func getSpendingAmount(for day: Int, from viewModel: SpendingHistoryViewModel) -> Int? {
        return viewModel.dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }

    static func getSpendingAmount(for date: Date, using calendar: Calendar, from viewModel: SpendingHistoryViewModel) -> Int? {
        let day = calendar.component(.day, from: date)
        return getSpendingAmount(for: day, from: viewModel)
    }

    static func truncatedText(_ text: String) -> String {
        let maxLength = 7
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
