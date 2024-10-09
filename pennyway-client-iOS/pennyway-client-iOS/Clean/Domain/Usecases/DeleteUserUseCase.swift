//
//  DeleteUserUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/27/24.
//

import Foundation

// MARK: - DeleteUserAccountUseCase

protocol DeleteUserAccountUseCase {
    /// 회원탈퇴를 실행하는 함수
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func execute(completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultDeleteUserAccountUseCase

class DefaultDeleteUserAccountUseCase: DeleteUserAccountUseCase {
    private let repository: DeleteUserAccountRepository

    init(repository: DeleteUserAccountRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Bool) -> Void) {
        repository.deleteUserAccount(completion: completion)
    }
}
