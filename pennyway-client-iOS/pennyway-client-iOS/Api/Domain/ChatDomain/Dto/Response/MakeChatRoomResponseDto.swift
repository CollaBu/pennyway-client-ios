
import Foundation

// MARK: - MakeChatRoomResponseDto

struct MakeChatRoomResponseDto: Codable {
    let code: String
    let data: MakeChatRoomData
}

// MARK: - MakeChatRoomData

struct MakeChatRoomData: Codable {
    let chatRoom: MakeChatRoomDetail
}

// MARK: - MakeChatRoomDetail

struct MakeChatRoomDetail: Codable {
    let id: Int64
    let title: String
    let description: String
    let backgroundImageUrl: String
    let isPrivate: Bool
    let isAdmin: Bool
    let participantCount: Int32
    let createdAt: String?
}
