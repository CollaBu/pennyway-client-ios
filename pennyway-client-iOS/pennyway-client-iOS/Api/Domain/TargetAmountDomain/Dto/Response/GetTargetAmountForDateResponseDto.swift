
import Foundation

// MARK: - GetTargetAmountForDateResponseDto

struct GetTargetAmountForDateResponseDto: Codable {
    let code: String
    let data: targetAmountData

    struct targetAmountData: Codable {
        let targetAmount: TargetAmount
    }
}

// MARK: - TargetAmount

struct TargetAmount: Codable {
    let year: Int
    let month: Int
    let targetAmountDetail: AmountDetail
    let totalSpending: Int
    let diffAmount: Int

}

struct AmountDetail: Codable {
    let id: Int
    let amount: Int
    let isRead: Bool
}
