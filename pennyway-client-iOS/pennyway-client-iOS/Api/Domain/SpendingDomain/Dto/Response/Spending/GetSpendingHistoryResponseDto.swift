import Foundation

// MARK: - GetSpendingHistoryResponseDto

struct GetSpendingHistoryResponseDto: Codable {
    let code: String
    let data: SpendingData

    struct SpendingData: Codable {
        let spending: Spending
    }
}
