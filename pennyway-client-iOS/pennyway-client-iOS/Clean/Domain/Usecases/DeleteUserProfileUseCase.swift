
import Foundation

// MARK: - DeleteUserProfileUseCase

/// 사용자 프로필사진을 삭제하는 usecase를 정의하는 프로토콜
protocol DeleteUserProfileUseCase {
    /// 사용자 프로필을 삭제하는 함수
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func delete(completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultDeleteUserProfileUseCase

class DefaultDeleteUserProfileUseCase: DeleteUserProfileUseCase {
    private let repository: ProfileImageRepository

    init(repository: ProfileImageRepository) {
        self.repository = repository
    }

    func delete(completion: @escaping (Bool) -> Void) {
        repository.deleteUserProfile { result in
            switch result {
            case let .success(result):
                completion(true)
                Log.debug("[DefaultDeleteUserProfileUseCase]-프로필 삭제 성공")
            case let .failure(error):
                completion(false)
                Log.debug("[DefaultDeleteUserProfileUseCase]-프로필 삭제 실패")
            }
        }
    }
}
