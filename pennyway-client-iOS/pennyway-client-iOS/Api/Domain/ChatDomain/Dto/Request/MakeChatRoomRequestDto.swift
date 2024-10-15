
import Foundation

public struct MakeChatRoomRequestDto: Encodable {
    let backgroundImageUrl: String

    public init(
        backgroundImageUrl: String
    ) {
        self.backgroundImageUrl = backgroundImageUrl
    }
}
