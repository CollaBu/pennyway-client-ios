// MARK: - Spending

struct Spending: Codable {
    let year: Int
    let month: Int
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
    let spendAt: String
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
