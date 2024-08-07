
import SwiftUI

class DiffAmountColorUtil {
    static func determineBackgroundColor(for diffAmount: Int64) -> Color {
        if diffAmount > 0 {
            return Color("Red01")
        } else if diffAmount < 0 {
            return Color("Ashblue01")
        } else {
            return Color("Yellow01")
        }
    }

    static func determineTextColor(for diffAmount: Int64) -> Color {
        if diffAmount > 0 {
            return Color("Red03")
        } else if diffAmount < 0 {
            return Color("Mint03")
        } else {
            return Color("Yellow02")
        }
    }

    static func determineText(for diffAmount: Int64) -> String {
        let diffAmountValue = NumberFormatterUtil.formatIntToDecimalString(abs(diffAmount))

        if diffAmount != 0 {
            return diffAmount < 0 ? "\(diffAmountValue)원 절약했어요" : "\(diffAmountValue)원 더 썼어요"
        } else {
            return "짝짝 당신은 천재 계산기!"
        }
    }
}
