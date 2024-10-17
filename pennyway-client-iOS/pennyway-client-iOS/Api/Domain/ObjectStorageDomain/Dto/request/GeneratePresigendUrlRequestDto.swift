
import Foundation

public struct GeneratePresigendUrlRequestDto: Encodable {
    let type: String
    let ext: String
    let chatroomId: Int64?

    private init(
        type: String,
        ext: String,
        chatroomId: Int64?
    ) {
        self.type = type
        self.ext = ext
        self.chatroomId = chatroomId
    }

    static func from(model: PresignedUrlType) -> GeneratePresigendUrlRequestDto {
        return GeneratePresigendUrlRequestDto(type: model.type, ext: model.ext, chatroomId: model.chatRoomId)
    }
}
