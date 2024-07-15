
import Foundation

// MARK: - AddSpendingHistoryResponseDto

struct AddSpendingHistoryResponseDto: Codable {
    let code: String
    let data: SpendingData

    struct SpendingData: Codable {
        let spending: Spending

        struct Spending: Codable {
            let id: Int
            let amount: Int
            let category: Category
            let spendAt: String
            let accountName: String
            let memo: String

            struct Category: Codable {
                let isCustom: Bool
                let id: Int
                let name: String
                let icon: String
            }
        }
    }
}
