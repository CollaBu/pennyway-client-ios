
import Foundation

// MARK: - getSpendingCustomCategoryListResponseDto

struct getSpendingCustomCategoryListResponseDto: Codable {
    let code: String
    let data: SpendingData

    struct SpendingData: Codable {
        let spendingCategories: [SpendingCategory]
    }
}
