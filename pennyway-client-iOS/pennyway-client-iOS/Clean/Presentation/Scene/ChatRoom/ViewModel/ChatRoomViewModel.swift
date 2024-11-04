//
//  ChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation
// MARK: - GetChatRoomViewModelInput

protocol ChatRoomViewModelInput {
    func getChatRoomDetail()
}

// MARK: - GetChatRoomViewModelOutput

protocol ChatRoomViewModelOutput {
    var roomDetailData: Observable<[ChatRoomDetailItemModel]> { get set }
}

// MARK: - GetChatRoomViewModel

protocol ChatRoomViewModel: ChatRoomViewModelInput, ChatRoomViewModelOutput {}

// MARK: - DefaultGetChatRoomViewModel

class DefaultChatRoomViewModel: ChatRoomViewModel {
    
    
    func getChatRoomDetail() {
        
    }
    
    var roomDetailData: Observable<[ChatRoomDetailItemModel]>
    
//    @Published var roomData: Observable<[ChatRoomItemModel]>
//
    private let chatRoomUseCase: ChatRoomUseCase
//
//    init(getChatRoomUseCase: GetChatRoomUseCase) {
//        self.getChatRoomUseCase = getChatRoomUseCase
//
//        roomData = Observable([ChatRoomItemModel(id: 0, title: "", description: "", backgroundImageUrl: "", isPrivate: false, isAdmin: false, participantCount: 0)])
//    }
//
//    /// 내 채팅방 조회 요청
//    func getChatRoom() {
//        getChatRoomUseCase.getChatRoom { [weak self] success, chatRooms in
//            DispatchQueue.main.async {
//                if success {
//                    if let chatRooms = chatRooms {
//                        self?.roomData.value = chatRooms.map { chatRoomDetail in
//                            return ChatRoomItemModel(
//                                id: chatRoomDetail.id,
//                                title: chatRoomDetail.title,
//                                description: chatRoomDetail.description,
//                                backgroundImageUrl: chatRoomDetail.backgroundImageUrl,
//                                isPrivate: chatRoomDetail.isPrivate,
//                                isAdmin: chatRoomDetail.isAdmin,
//                                participantCount: chatRoomDetail.participantCount
//                            )
//                        }
//                        Log.debug("[ChatViewModel]: 내 채팅방 조회 성공")
//                    }
//                } else {
//                    Log.debug("[ChatViewModel]: 내 채팅방 조회 실패")
//                }
//            }
//        }
//    }
}
