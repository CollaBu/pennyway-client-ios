
import Foundation

public struct GetCategorySpendingCountRequestDto: Encodable {
    let type: String

    public init(
        type: String
    ) {
        self.type = type
    }
}
