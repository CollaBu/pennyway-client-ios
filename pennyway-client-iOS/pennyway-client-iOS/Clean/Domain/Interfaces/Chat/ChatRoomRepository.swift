//
//  ChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation


protocol ChatRoomRepository {
    func getChatRoomDetail(completion: @escaping (Result<[ChatRoomDetailInfo], any Error>) -> Void)
}
