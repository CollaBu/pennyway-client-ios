//
//  DeleteUserProfileUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/20/24.
//

import Foundation

// MARK: - DeleteUserProfileUseCase

/// 사용자 프로필사진을 삭제하는 usecase를 정의하는 프로토콜
protocol DeleteUserProfileUseCase {
    /// 사용자 프로필을 삭제하는 함수
    /// - Returns: `UserProfileItemModel` 타입의 업데이트된 사용자 프로필 데이터를 반환.
    func delete() -> UserProfileItemModel
}

// MARK: - DefaultDeleteUserProfileUseCase

class DefaultDeleteUserProfileUseCase: DeleteUserProfileUseCase {
    private let repository: FetchUserProfileProtocol

    init(repository: FetchUserProfileProtocol) {
        self.repository = repository
    }

    func delete() -> UserProfileItemModel {
        let deletedUserProfileUrl = repository.deleteUserProfile()

        // 삭제된 profileUrl을 UserProfileItemModel을 생성해서 전달
        var updateUserProfileUrl = UserProfileItemModel(userData: repository.fetchUserProfile())
        updateUserProfileUrl.profileImageUrl = deletedUserProfileUrl
        return updateUserProfileUrl
    }
}
