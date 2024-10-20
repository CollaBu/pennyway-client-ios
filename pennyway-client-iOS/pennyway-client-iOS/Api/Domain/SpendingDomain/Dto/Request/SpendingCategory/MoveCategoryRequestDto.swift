
import Foundation

public struct MoveCategoryRequestDto: Encodable {
    let fromType: String
    let toId: Int
    let toType: String

    public init(
        fromType: String,
        toId: Int,
        toType: String
    ) {
        self.fromType = fromType
        self.toId = toId
        self.toType = toType
    }
}
