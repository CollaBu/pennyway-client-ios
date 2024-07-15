
import Foundation

public struct DeleteSpendingHistoryRequestDto: Encodable {
    let spendingIds: [Int]

    public init(
        spendingIds: [Int]
    ) {
        self.spendingIds = spendingIds
    }
}
