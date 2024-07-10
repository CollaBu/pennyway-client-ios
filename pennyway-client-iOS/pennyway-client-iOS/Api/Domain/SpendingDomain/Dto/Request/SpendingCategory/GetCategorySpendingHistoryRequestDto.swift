
import Foundation

public struct GetCategorySpendingHistoryRequestDto: Encodable {
    let type: String
    let size: String
    let page: String
    let sort: String
    let direction: String

    public init(
        type: String,
        size: String,
        page: String,
        sort: String,
        direction: String
    ) {
        self.type = type
        self.size = size
        self.page = page
        self.sort = sort
        self.direction = direction
    }
}
