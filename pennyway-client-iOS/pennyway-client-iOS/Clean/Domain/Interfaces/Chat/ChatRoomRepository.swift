//
//  ChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

protocol ChatRoomRepository {
    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Result<ChatRoomDetailInfo, Error>) -> Void)
    func getPreviousChat(chatRoomId: Int64, lastMessageId: Int64, completion: @escaping (Result<PreviousMessage, Error>) -> Void)
    func getChatMembers(chatRoomId: Int64, ids: [Int64], completion: @escaping (Result<[ChatMember], Error>) -> Void)
    /// 채팅방 나가기 기능을 수행하는  함수
    func deleteChatRoom(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void)
}
