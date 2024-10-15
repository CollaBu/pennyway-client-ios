
import Foundation

public struct PendChatRoomRequestDto: Encodable {
    let title: String
    let description: String
    let password: Int32

    public init(
        title: String,
        description: String,
        password: Int32
    ) {
        self.title = title
        self.description = description
        self.password = password
    }
}
