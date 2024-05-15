
import Foundation

public struct CheckSpendingHistoryRequestDto: Encodable {
    let year: String
    let month: String

    public init(
        year: String,
        month: String
    ) {
        self.year = year
        self.month = month
    }
}
