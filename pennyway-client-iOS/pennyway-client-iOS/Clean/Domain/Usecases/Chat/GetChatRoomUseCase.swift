//
//  GetChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/24/24.
//

import Foundation
import UIKit

// MARK: - GetChatRoomUseCase

protocol GetChatRoomUseCase {
    func getChatRoom(completion: @escaping (Bool, [ChatRoomItemModel]?) -> Void)
}

// MARK: - DefaultGetChatRoomUseCase

class DefaultGetChatRoomUseCase: GetChatRoomUseCase {
    private let repository: GetChatRoomRepository

    init(repository: GetChatRoomRepository) {
        self.repository = repository
    }

    func getChatRoom(completion: @escaping (Bool, [ChatRoomItemModel]?) -> Void) {
        repository.getChatRoom { result in
            switch result {
            case let .success(chatRooms): // chatRoom은 ChatRoom 타입
                // ChatRoom 데이터를 ChatRoomItemModel로 변환

                let chatRoomItemModels = chatRooms.map { chatRoom in
                    return ChatRoomItemModel(
                        id: chatRoom.id,
                        title: chatRoom.title,
                        description: chatRoom.description,
                        backgroundImageUrl: chatRoom.background_image_url,
                        isPrivate: chatRoom.isPrivate,
                        isAdmin: chatRoom.isAdmin,
                        participantCount: chatRoom.participantCount
                    )
                }
                Log.debug("[GetChatRoomUseCase] 내 채팅 조회 성공")
                completion(true, chatRoomItemModels) // 성공 시 데이터와 함께 true 전달

            case let .failure(error):
                Log.debug("[GetChatRoomUseCase] 내 채팅 조회 실패: \(error)")
                completion(false, nil) // 실패 시 false와 nil 전달
            }
        }
    }

    /// URL을 사용해 이미지를 비동기적으로 로드하는 함수
    private func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // URLSession을 사용해 이미지 다운로드
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
            }
        }.resume()
    }
}
