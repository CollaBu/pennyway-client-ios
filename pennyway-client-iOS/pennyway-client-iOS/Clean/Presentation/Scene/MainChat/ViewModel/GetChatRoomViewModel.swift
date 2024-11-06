//
//  GetChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/9/24.
//

import Foundation
import UIKit

// MARK: - GetChatRoomViewModelInput

protocol GetChatRoomViewModelInput {
    func getChatRoom()
    func searchChatRoom(target: String)
    func initSearch()
}

// MARK: - GetChatRoomViewModelOutput

protocol GetChatRoomViewModelOutput {
    var roomData: Observable<[ChatRoomItemModel]> { get set }
    var searchRoomData: Observable<[SearchChatRoomItemModel]> { get set }
}

// MARK: - GetChatRoomViewModel

protocol GetChatRoomViewModel: GetChatRoomViewModelInput, GetChatRoomViewModelOutput {}

// MARK: - DefaultGetChatRoomViewModel

class DefaultGetChatRoomViewModel: GetChatRoomViewModel {
    @Published var roomData: Observable<[ChatRoomItemModel]>
    @Published var searchRoomData: Observable<[SearchChatRoomItemModel]>

    private let getChatRoomUseCase: GetChatRoomUseCase
    private let searchChatRoomUseCase: SearchChatRoomUseCase
    private var currentPageNumber: Int = 0
    private var hasNext: Bool = true // 다음 페이지가 있는지 여부

    /// 검색 초기화
    func initSearch() {
        searchRoomData.value = []
        currentPageNumber = 0
        hasNext = true
    }

    init(getChatRoomUseCase: GetChatRoomUseCase, searchChatRoomUseCase: SearchChatRoomUseCase) {
        self.getChatRoomUseCase = getChatRoomUseCase
        self.searchChatRoomUseCase = searchChatRoomUseCase

        roomData = Observable([])
        searchRoomData = Observable([])
    }

    /// 내 채팅방 조회 요청
    func getChatRoom() {
        getChatRoomUseCase.getChatRoom { [weak self] success, chatRooms in
            DispatchQueue.main.async {
                if success {
                    if let chatRooms = chatRooms {
                        self?.roomData.value = chatRooms.map { chatRoomDetail in
                            return ChatRoomItemModel(
                                id: chatRoomDetail.id,
                                title: chatRoomDetail.title,
                                description: chatRoomDetail.description,
                                backgroundImageUrl: chatRoomDetail.backgroundImageUrl,
                                isPrivate: chatRoomDetail.isPrivate,
                                isAdmin: chatRoomDetail.isAdmin,
                                participantCount: chatRoomDetail.participantCount
                            )
                        }
                        Log.debug("[ChatViewModel]: 내 채팅방 조회 성공")
                    }
                } else {
                    Log.debug("[ChatViewModel]: 내 채팅방 조회 실패")
                }
            }
        }
    }

    /// 채팅 검색 조회 요청
    func searchChatRoom(target: String) {
        guard hasNext else {
            return
        }

        searchChatRoomUseCase.execute(target: target, page: currentPageNumber) { [weak self] success, chatRooms in
            DispatchQueue.main.async {
                if success {
                    if let chatRooms = chatRooms {
                        self?.searchRoomData.value = chatRooms.map { chatRoomDetail in
                            return SearchChatRoomItemModel(
                                id: chatRoomDetail.id,
                                title: chatRoomDetail.title,
                                description: chatRoomDetail.description, 
                                isPrivate: chatRoomDetail.isPrivate,
                                backgroundImageUrl: chatRoomDetail.backgroundImageUrl,
                                participantCount: chatRoomDetail.participantCount
                            )
                        }
                        Log.debug("[ChatViewModel]: 채팅방 검색 성공")
                    }
                }
            }
        }
    }
}
