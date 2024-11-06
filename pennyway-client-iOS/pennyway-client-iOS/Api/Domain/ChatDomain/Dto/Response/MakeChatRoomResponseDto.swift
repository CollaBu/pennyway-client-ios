
import Foundation

// MARK: - MakeChatRoomResponseDto

struct MakeChatRoomResponseDto: Codable {
    let code: String
    let data: MakeChatRoomData
}

// MARK: - MakeChatRoomData

struct MakeChatRoomData: Codable {
    let chatRoom: ChatRoomDetail
}
