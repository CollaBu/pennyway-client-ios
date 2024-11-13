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
}
