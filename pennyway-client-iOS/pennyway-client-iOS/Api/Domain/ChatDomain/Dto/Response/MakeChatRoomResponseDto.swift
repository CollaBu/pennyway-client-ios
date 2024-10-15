
import Foundation

// MARK: - MakeChatRoomResponseDto

struct MakeChatRoomResponseDto: Codable {
    let code: String
    let data: ChatRoomData

    struct ChatRoomData: Codable {
        let chatRoom: ChatRoomDetail
    }
}

// MARK: - ChatRoomDetail

struct ChatRoomDetail: Codable {
    let id: Int64
    let title: String
    let description: String
    let backgroundImageUrl: String
    let isPrivate: Bool
    let participantCount: Int32
    let createdAt: String
}
