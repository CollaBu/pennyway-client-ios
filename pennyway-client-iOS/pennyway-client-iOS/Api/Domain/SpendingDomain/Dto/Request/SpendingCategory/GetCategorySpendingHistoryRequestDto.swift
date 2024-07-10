
import Foundation

public struct GetCategorySpendingHistoryRequestDto: Encodable {
    let type: String
    let size: String
    let sort: String
    let direction: String

    public init(
        type: String,
        size: String,
        sort: String,
        direction: String
    ) {
        self.type = type
        self.size = size
        self.sort = sort
        self.direction = direction
    }
}
