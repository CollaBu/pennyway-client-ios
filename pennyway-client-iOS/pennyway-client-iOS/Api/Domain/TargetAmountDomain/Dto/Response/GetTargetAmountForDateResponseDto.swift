
import Foundation

// MARK: - GetTargetAmountForDateResponseDto

struct GetTargetAmountForDateResponseDto: Codable {
    let code: String
    let data: targetAmountData

    struct targetAmountData: Codable {
        let targetAmount: TargetAmount
    }
}
