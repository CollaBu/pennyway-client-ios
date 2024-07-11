
import Foundation

public struct GetCategorySpendingHistoryRequestDto: Encodable {
    let type: String
    let size: String
    let page: String

    public init(
        type: String,
        size: String,
        page: String
    ) {
        self.type = type
        self.size = size
        self.page = page
    }
}
