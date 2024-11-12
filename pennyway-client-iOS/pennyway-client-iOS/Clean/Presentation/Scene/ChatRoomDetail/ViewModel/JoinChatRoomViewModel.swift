//
//  JoinChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/7/24.
//

import Foundation

// MARK: - JoinChatRoomViewModelInput

protocol JoinChatRoomViewModelInput {
    func joinChatRoom(chatRoomId: Int64, password: String, completion: @escaping (Bool) -> Void)
    func validatePwForm(password: String)
}

// MARK: - JoinChatRoomViewModelOutput

protocol JoinChatRoomViewModelOutput {
    var isFormValid: Bool { get set }
    var isPasswordInvalid: Bool { get set }
}

// MARK: - JoinChatRoomViewModel

protocol JoinChatRoomViewModel: JoinChatRoomViewModelInput, JoinChatRoomViewModelOutput {}

// MARK: - DefaultJoinChatRoomViewModel

class DefaultJoinChatRoomViewModel: JoinChatRoomViewModel {
    @Published var isFormValid: Bool = false // 버튼 활성화 여부
    @Published var isPasswordInvalid: Bool = false // 4004 오류 상태 표시

    private let joinChatRoomUseCase: JoinChatRoomUseCase

    init(joinChatRoomUseCase: JoinChatRoomUseCase) {
        self.joinChatRoomUseCase = joinChatRoomUseCase
    }

    /// 채팅방 가입 검사 메서드
    func validatePwForm(password: String) {
        isFormValid = password.count >= 1 && password.count <= 6
    }

    /// 채팅방 가입 요청
    func joinChatRoom(chatRoomId: Int64, password: String, completion: @escaping (Bool) -> Void) {
        joinChatRoomUseCase.execute(chatRoomId: chatRoomId, password: password) { result in
            switch result {
            case let .success(chatRoom):
                Log.debug("[JoinChatRoomViewModel]: 채팅방 가입 성공 - 채팅방 ID: \(chatRoom.id)")
                self.isPasswordInvalid = false
                completion(true)

            case let .failure(error):
                Log.fault("[JoinChatRoomViewModel]: 채팅방 가입 실패, 오류: \(error)")
                if let joinChatRoomError = error as? JoinChatRoomError {
                    switch joinChatRoomError {
                    case .invalidPassword:
                        self.isPasswordInvalid = true 
                        Log.debug("뷰모델:\(self.isPasswordInvalid)")
                        completion(false)
                    case .other:
                        self.isPasswordInvalid = false
                        completion(false)
                    }
                }
            }
        }
    }
}
