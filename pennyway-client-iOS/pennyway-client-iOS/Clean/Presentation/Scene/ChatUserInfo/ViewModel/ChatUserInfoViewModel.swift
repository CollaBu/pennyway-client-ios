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
    func setChatMemberInfo(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void)
    func delegateToAdmin(completion: @escaping (Bool) -> Void)
}

// MARK: - ChatUserInfoViewModelOutput

protocol ChatUserInfoViewModelOutput {
    var isBanSuccessful: Bool { get set }
    var isDelegateSuccessful: Bool { get set }
}

// MARK: - ChatUserInfoViewModel

protocol ChatUserInfoViewModel: ChatUserInfoViewModelInput, ChatUserInfoViewModelOutput {}

// MARK: - DefaultChatUserInfoViewModel

class DefaultChatUserInfoViewModel: ChatUserInfoViewModel, ObservableObject {
    @Published var chatRoomId: Int64
    @Published var chatMemberId: Int64
    @Published var isBanSuccessful: Bool = false // 강제 추방 성공 상태 관리
    @Published var isDelegateSuccessful: Bool = false // 관리자 위임 성공여부 상태 관리

    private let userInfoUseCase: UserInfoUseCase

    init(userInfoUseCase: UserInfoUseCase) {
        self.userInfoUseCase = userInfoUseCase

        // 초기화
        chatRoomId = 0
        chatMemberId = 0
    }

    /// 채팅 멤버 정보를 설정
    func setChatMemberInfo(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void) {
        self.chatRoomId = chatRoomId
        self.chatMemberId = chatMemberId
        completion(true)
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

    /// 관리자 위임
    func delegateToAdmin(completion: @escaping (Bool) -> Void) {
        userInfoUseCase.delegateToAdmin(chatRoomId: chatRoomId, chatMemberId: chatMemberId) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.isDelegateSuccessful = true
                    Log.debug("[DefaultChatUserInfoViewModel] - isDelegateSuccessful: \(String(describing: self?.isDelegateSuccessful))")
                    completion(true)
                }
            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅방 삭제 실패: \(error.localizedDescription)")

                switch error {
                case .mismatchConflict, .other, .notAdmin, .notFound:
                    completion(false)
                }
            }
        }
    }
}
