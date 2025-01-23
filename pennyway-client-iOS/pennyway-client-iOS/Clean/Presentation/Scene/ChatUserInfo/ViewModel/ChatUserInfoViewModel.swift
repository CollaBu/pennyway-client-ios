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
    func setChatMemberInfo(chatRoomId: Int64, chatMemberId: Int64)
}

// MARK: - ChatUserInfoViewModelOutput

protocol ChatUserInfoViewModelOutput {
    var isBanSuccessful: Bool { get set }
}

// MARK: - ChatUserInfoViewModel

protocol ChatUserInfoViewModel: ChatUserInfoViewModelInput, ChatUserInfoViewModelOutput {}

// MARK: - DefaultChatUserInfoViewModel

class DefaultChatUserInfoViewModel: ChatUserInfoViewModel, ObservableObject {
    @Published var chatRoomId: Int64
    @Published var chatMemberId: Int64
    @Published var isBanSuccessful: Bool = false // 강제 추방 성공 상태 관리

    private let userInfoUseCase: UserInfoUseCase

    init(userInfoUseCase: UserInfoUseCase) {
        self.userInfoUseCase = userInfoUseCase

        // 초기화
        chatRoomId = 0
        chatMemberId = 0
    }

    /// 채팅 멤버 정보를 설정
    func setChatMemberInfo(chatRoomId: Int64, chatMemberId: Int64) {
        self.chatRoomId = chatRoomId
        self.chatMemberId = chatMemberId
    }

    /// 채팅멤버 강제 추방
    func banChatMember() {
        userInfoUseCase.banChatMember(chatRoomId: chatRoomId, chatMemberId: chatMemberId) { [weak self] isSuccess in
            DispatchQueue.main.async {
                self?.isBanSuccessful = isSuccess
                Log.debug("[DefaultChatUserInfoViewModel] - isBanSuccessful: \(self!.isBanSuccessful)")
            }
        }
    }
}
