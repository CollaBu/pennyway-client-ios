//
//  EditChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

import Foundation
import UIKit

protocol EditChatRoomRepository {
    func editChatRoom(roomData: EditChatRoomItemModel, completion: @escaping (Result<MakeChatRoomData, Error>) -> Void)
}
