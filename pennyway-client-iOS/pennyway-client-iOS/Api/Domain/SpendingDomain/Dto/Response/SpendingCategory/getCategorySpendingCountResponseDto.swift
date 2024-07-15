import Foundation

// MARK: - getCategorySpendingCountResponseDto

struct getCategorySpendingCountResponseDto: Codable {
    let code: String
    let data: SpendingCount

    struct SpendingCount: Codable {
        let totalCount: Int
    }
}
