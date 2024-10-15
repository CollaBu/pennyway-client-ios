
import Foundation

// MARK: - PendChatRoomResponseDto

struct PendChatRoomResponseDto: Codable {
    let code: String
    let data: ChatRoomData

    struct ChatRoomData: Codable {
        let chatRoomId: Int64
    }
}
