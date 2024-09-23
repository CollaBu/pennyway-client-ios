
import Foundation

// MARK: - DeleteUserProfileUseCase

/// 사용자 프로필사진을 삭제하는 usecase를 정의하는 프로토콜
protocol DeleteUserProfileUseCase {
    /// 사용자 프로필을 삭제하는 함수
    /// - Returns: `UserProfileItemModel` 타입의 업데이트된 사용자 프로필 데이터를 반환.
    func delete(completion: @escaping (Result<ProfileImageItemModel, Error>) -> Void)
}

// MARK: - DefaultDeleteUserProfileUseCase

class DefaultDeleteUserProfileUseCase: DeleteUserProfileUseCase {
    private let repository: ProfileImageRepository

    init(repository: ProfileImageRepository) {
        self.repository = repository
    }

    func delete(completion _: @escaping (Result<ProfileImageItemModel, Error>) -> Void) {
        repository.deleteUserProfile { result in
            switch result {
            case let .success(result):
                ProfileImageItemModel(profileImageUrl: "")
            case let .failure(error):
                Log.debug("프로필 삭제 실패")
            }
        }
    }
}
