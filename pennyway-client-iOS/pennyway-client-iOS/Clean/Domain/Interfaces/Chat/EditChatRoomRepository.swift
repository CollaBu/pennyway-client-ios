//
//  EditChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

import Foundation
import UIKit

protocol EditChatRoomRepository {
    func getChatAdminMode(chatRoomId: Int64, completion: @escaping (Result<AdminModeChatRoom, Error>) -> Void)
    func editChatRoom(roomData: AdminModeChatRoomItemModel, completion: @escaping (Result<MakeChatRoomData, Error>) -> Void)
    func handleChatRoomAlarm(chatRoomId: Int64, chatRoomAlarm: ChatRoomAlarmType, completion: @escaping (Bool) -> Void) 
}
