
import Foundation


// MARK: - AddSpendingCustomCategoryResponseDto

struct AddSpendingCustomCategoryResponseDto: Codable {
    let code: String
    let data: SpendingCategory
    
    struct SpendingData: Codable {
        let spendingCategory: SpendingCategory
    }
}
