
import Foundation

// MARK: - GetTotalTargetAmountResponseDto

struct GetTotalTargetAmountResponseDto: Codable {
    let code: String
    let data: targetAmountData

    struct targetAmountData: Codable {
        let targetAmounts: [TargetAmount]
    }
}

// MARK: - TargetAmount

struct TargetAmount: Codable {
    let year: Int
    let month: Int
    let targetAmount: Amount
    let totalSpending: Int
    let diffAmount: Int

    struct Amount: Codable {
        let id: Int
        let amount: Int
    }
}
