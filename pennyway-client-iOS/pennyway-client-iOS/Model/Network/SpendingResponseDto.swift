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
    var amount: Int
    var category: SpendingCategory
    var spendAt: String
    var accountName: String
    var memo: String

    mutating func update(spending: IndividualSpending) {
        amount = spending.amount
        category = spending.category
        spendAt = spending.spendAt
        accountName = spending.accountName
        memo = spending.memo
    }
}

// MARK: - SpendingCategory

struct SpendingCategory: Codable {
    let isCustom: Bool
    let id: Int
    let name: String
    let icon: String
}
