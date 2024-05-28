
import Foundation

// MARK: - getSpendingCustomCategoryListResponseDto

struct getSpendingCustomCategoryListResponseDto: Codable {
    let code: String
    let data: SpendingCategory
    
    struct SpendingData: Codable {
        let spendingCategories: SpendingCategory
    }
}
