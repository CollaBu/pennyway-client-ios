
import Foundation

// MARK: - AddSpendingHistoryResponseDto

struct AddSpendingHistoryResponseDto: Codable {
    let code: String
    let data: SpendingData

    struct SpendingData: Codable {
        let spending: IndividualSpending
    }
}
