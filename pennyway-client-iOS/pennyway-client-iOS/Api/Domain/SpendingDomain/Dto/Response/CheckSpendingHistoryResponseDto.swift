import Foundation

// MARK: - CheckSpendingHistoryResponseDto
struct CheckSpendingHistoryResponseDto: Codable {
    let code: String
    let data: Spending
}

// MARK: - Spending
struct Spending: Codable {
    let year: Int
    let month: Int
    let monthlyTotalAmount: Int
    let dailySpendings: [DailySpending]
}

// MARK: - DailySpending
struct DailySpending: Codable {
    let day: Int
    let dailyTotalAmount: Int
    let individuals: [IndividualSpending]
}

// MARK: - IndividualSpending
struct IndividualSpending: Codable {
    let id: Int
    let amount: Int
    let category: SpendingCategory
    let spendAt: Date
    let accountName: String
    let memo: String
}

// MARK: - SpendingCategory
struct SpendingCategory: Codable {
    let isCustom: Bool
    let id: Int
    let name: String
    let icon: String
}
