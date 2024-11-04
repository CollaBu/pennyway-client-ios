//
//  GetChatRoomDetailUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - LoginUseCase

protocol ChatRoomUseCase {
    func getChatRoomDetail(chatRoodId: Int64, completion: @escaping (Result<ChatRoomDetailItemModel, Error>) -> Void)

}

// MARK: - DefaultLoginUseCase

class DefaultChatRoomUseCase: ChatRoomUseCase {
    private let repository: ChatRoomRepository
    
    init(repository: ChatRoomRepository) {
        self.repository = repository
    }
    
    func getChatRoomDetail(chatRoodId: Int64, completion: @escaping (Result<ChatRoomDetailItemModel, Error>) -> Void) {
//        repository.getChatRoomDetail(chatRoodId: chatRoodId) { [weak self] result in
//            switch result {
//            case .success:
//                completion(true)
//            case .failure:
//                completion(false)
//            }
//        }
    }
}
