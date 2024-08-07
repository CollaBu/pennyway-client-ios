
import Foundation

public struct MoveCategoryRequestDto: Encodable {
    let fromType: String
    let toId: String
    let toType: String

    public init(
        fromType: String,
        toId: String,
        toType: String
    ) {
        self.fromType = fromType
        self.toId = toId
        self.toType = toType
    }
}
