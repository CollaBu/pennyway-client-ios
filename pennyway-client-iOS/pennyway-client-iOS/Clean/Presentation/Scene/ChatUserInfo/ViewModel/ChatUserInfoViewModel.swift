//
//  ChatUserInfoViewModel.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 1/21/25.
//

import Foundation

// MARK: - ChatUserInfoViewModelInput

protocol ChatUserInfoViewModelInput {
    func banChatMember()
}

// MARK: - ChatUserInfoViewModelOutput

protocol ChatUserInfoViewModelOutput {}

// MARK: - ChatUserInfoViewModel

protocol ChatUserInfoViewModel: ChatUserInfoViewModelInput, ChatUserInfoViewModelOutput {}

// MARK: - DefaultChatUserInfoViewModel

class DefaultChatUserInfoViewModel: ChatUserInfoViewModel, ObservableObject {
    @Published var chatRoomId: Int64
    @Published var chatMemberId: Int64

    private let userInfoUseCase: UserInfoUseCase

    init(userInfoUseCase: UserInfoUseCase) {
        self.userInfoUseCase = userInfoUseCase

        // 초기화
        chatRoomId = 0
        chatMemberId = 0
    }

    /// 채팅멤버 강제 추방
    func banChatMember() {
        userInfoUseCase.banChatMember(chatRoomId: chatRoomId, chatMemberId: chatMemberId)
    }
}
