//
//  FetchUserProfileUseCase.swift
//  clean-architecture-seminar
//
//  Created by 최희진 on 9/4/24.
//

import Foundation

// MARK: - FetchUserProfileUseCase

/// 사용자 프로필 데이터를 가져오는 usecase를 정의하는 프로토콜
protocol FetchUserProfileUseCase {
    /// 사용자 프로필 데이터를 가져오는 함수.
    /// - Returns: `UserModel` 타입의 사용자 프로필 데이터를 반환.
    func execute() -> UserModel
}

// MARK: - DefaultFetchUserProfileUseCase

class DefaultFetchUserProfileUseCase: FetchUserProfileUseCase {
    private let repository: FetchUserProfileProtocol

    init(repository: FetchUserProfileProtocol) {
        self.repository = repository
    }

    func execute() -> UserModel {
        return repository.fetchUserProfile()
    }
}
