
import Foundation

// MARK: - getCategorySpendingHistoryResponseDto

struct getCategorySpendingHistoryResponseDto: Codable {
    let code: String
    let data: SpendingData

    struct SpendingData: Codable {
        let spendings: SpendingDataPage
    }
}

// MARK: - SpendingDataPage

struct SpendingDataPage: Codable {
    let content: [Spending]
    let currentPageNumber: Int
    let pageSize: Int
    let numberOfElements: Int
    let hasNext: Bool
}
