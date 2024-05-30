
import Foundation

public struct AddSpendingHistoryRequestDto: Encodable {
    let amount: Int
    let categoryId: Int
    let icon: String
    let spendAt: String
    let accountName: String
    let memo: String

    public init(
        amount: Int,
        categoryId: Int,
        icon: String,
        spendAt: String,
        accountName: String,
        memo: String
    ) {
        self.amount = amount
        self.categoryId = categoryId
        self.icon = icon
        self.spendAt = spendAt
        self.accountName = accountName
        self.memo = memo
    }
}
