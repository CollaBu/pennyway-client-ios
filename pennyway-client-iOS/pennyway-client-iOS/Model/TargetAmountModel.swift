// MARK: - TargetAmount

struct TargetAmount: Codable {
    var year: Int
    var month: Int
    var targetAmountDetail: AmountDetail
    var totalSpending: Int
    var diffAmount: Int
}

// MARK: - AmountDetail

struct AmountDetail: Codable {
    var id: Int
    var amount: Int
    var isRead: Bool
}

// MARK: - RecentTargetAmount

struct RecentTargetAmount: Codable {
    let isPresent: Bool
    let year: Int?
    let month: Int?
    let amount: Int?
}
