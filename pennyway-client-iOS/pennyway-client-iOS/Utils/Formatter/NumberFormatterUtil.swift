
import Foundation

class NumberFormatterUtil {
    /// 정수를 100,000 형식으로 변환
    static func formatIntToDecimalString(_ number: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    /// 문자열을 100,000 형식으로 변환
    static func formatStringToDecimalString(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
           
        if digits.isEmpty {
            return ""
        }
                
        if let number = Int(digits), number <= MaxValue.maxValue { // 정수 최댓값 넘지 않은 경우
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: number)) ?? String(number)
        } else { // 정수 최댓값 넘은 경우
            let truncatedDigits = String(digits.prefix(digits.count - 1))
            if let truncatedNumber = Int(truncatedDigits), truncatedNumber <= MaxValue.maxValue {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                return numberFormatter.string(from: NSNumber(value: truncatedNumber)) ?? String(truncatedNumber)
            } else {
                return truncatedDigits
            }
        }
    }
}
