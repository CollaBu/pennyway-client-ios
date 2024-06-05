
import Foundation

// MARK: - GetTotalTargetAmountResponseDto

struct GetTotalTargetAmountResponseDto: Codable {
    let code: String
    let data: targetAmountData

    struct targetAmountData: Codable {
        let targetAmounts: [TargetAmount]
    }
}
