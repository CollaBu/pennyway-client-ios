//
//  JoinChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/7/24.
//

import Foundation

// MARK: - JoinChatRoomViewModelInput

protocol JoinChatRoomViewModelInput {
    func joinChatRoom()
    func validatePwForm(password: String)
    func validateName(name: String)
}

// MARK: - JoinChatRoomViewModelOutput

protocol JoinChatRoomViewModelOutput {
    var isFormValid: Bool { get set }
}

// MARK: - JoinChatRoomViewModel

protocol JoinChatRoomViewModel: JoinChatRoomViewModelInput, JoinChatRoomViewModelOutput {}

// MARK: - DefaultJoinChatRoomViewModel

class DefaultJoinChatRoomViewModel: JoinChatRoomViewModel {
    @Published var isFormValid: Bool = false // 버튼 활성화 여부

    private let joinChatRoomUseCase: JoinChatRoomUseCase

    init(joinChatRoomUseCase: JoinChatRoomUseCase) {
        self.joinChatRoomUseCase = joinChatRoomUseCase
    }

    /// 채팅방 가입 검사 메서드
    func validatePwForm(password: String) {
        isFormValid = password.count == 6
    }

    /// 채팅방 가입 닉네임 검사 메서드
    func validateName(name: String) {
        let nameRegex = "^[가-힣a-zA-Z]{2,8}$"
        isFormValid = NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }

    /// 채팅방 가입 요청
    func joinChatRoom() {
//        joinChatRoomUseCase.execute(chatRoomId: <#T##Int64#>, password: <#T##String#>)
    }
}
