//
//  ChatStompRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation

protocol ChatStompRepository {
    func connect()
    func disconnect()
    func sendMessage(message: String, chatRoomId: Int64, contentType: String)
    func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64)
    func subscribeToChatRoom(chatRoomId: Int64)
    func sendViewState(status: String, chatRoomId: Int64?)
}
