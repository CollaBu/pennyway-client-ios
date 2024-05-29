
import Foundation

// MARK: - AddSpendingCustomCategoryResponseDto

struct AddSpendingCustomCategoryResponseDto: Codable {
    let code: String
    let data: SpendingData

    struct SpendingData: Codable {
        let spendingCategory: SpendingCategory
    }
}
