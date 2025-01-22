//
//  GetChatRoomResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/31/24.
//

// MARK: - GetChatRoomResponseDto

struct GetChatRoomResponseDto: Codable {
    let code: String
    let data: ChatRoomData
}

// MARK: - ChatRoomData

struct ChatRoomData: Codable {
    let chatRooms: [ChatRoomDetail]
}

// MARK: - ChatRoomDetail

public struct ChatRoomDetail: Codable, MakeFullImageURL {
    let id: Int64
    let title: String
    let description: String
    let backgroundImageUrl: String
    let isPrivate: Bool
    let isAdmin: Bool
    let participantCount: Int32
    let createdAt: String?
    let lastMessage: GetMessage?
    let unreadMessageCount: Int64

    init(id: Int64, title: String, description: String, backgroundImageUrl: String, isPrivate: Bool, isAdmin: Bool, participantCount: Int32, createdAt: String?, lastMessage: GetMessage, unreadMessageCount: Int64) {
        self.id = id
        self.title = title
        self.description = description
        self.backgroundImageUrl = backgroundImageUrl
        self.isPrivate = isPrivate
        self.isAdmin = isAdmin
        self.participantCount = participantCount
        self.createdAt = createdAt
        self.lastMessage = lastMessage
        self.unreadMessageCount = unreadMessageCount
    }

    /// 채팅방 조회 응답 DTO를 Model 타입으로 변환
    /// - Parameters:
    ///     - dto: ChatRoomDetail을 인자로 받음
    ///     - cdnUrl: 응답으로 받은 url을 http형식의 url로 변환하기 위함
    static func toChatRoom(dto: ChatRoomDetail, cdnUrl: String) -> ChatRoom {
        // 이미지 url을 http형식으로 변환
        let completeBackgroundImageUrl = dto.backgroundImageUrl.isEmpty
            ? dto.backgroundImageUrl
            : createFullURL(with: cdnUrl, pathComponent: dto.backgroundImageUrl)

        // lastMessage가 nil일 경우 기본 LastMessage 생성
        let defaultLastMessage = Message(
            chatRoomId: 0,
            chatId: 0,
            content: "",
            contentType: ContentType.text,
            categoryType: CategoryType.normal,
            createdAt: "",
            senderId: 0
        )

        return ChatRoom(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            backgroundImageUrl: completeBackgroundImageUrl,
            isPrivate: dto.isPrivate,
            isAdmin: dto.isAdmin,
            participantCount: dto.participantCount,
            createdAt: dto.createdAt ?? "",
            lastMassage: dto.lastMessage != nil ? Message(
                chatRoomId: dto.lastMessage!.chatRoomId,
                chatId: dto.lastMessage!.chatId,
                content: dto.lastMessage!.content,
                contentType: dto.lastMessage!.contentType,
                categoryType: dto.lastMessage!.categoryType,
                createdAt: dto.lastMessage!.createdAt,
                senderId: dto.lastMessage!.senderId
            ) : defaultLastMessage,
            unreadMessageCount: dto.unreadMessageCount)
    }
}
