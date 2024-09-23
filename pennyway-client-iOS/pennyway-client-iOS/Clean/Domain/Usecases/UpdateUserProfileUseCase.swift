
import Foundation
import SwiftUI

// MARK: - UpdateUserProfileUseCase

/// 사용자 프로필사진을 변경하여 서버에 바뀐 사진을 전송하는 usecase를 정의하는 프로토콜
protocol UpdateUserProfileUseCase {
    /// 프로필 이미지 URL을 가져오는 함수
    func loadProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)

    /// 변경된 프로필 사진을 서버에 전송하는 함수
    /// - Returns: `String` 타입의 업데이트된 사용자 프로필 데이터를 반환.
    func update(from url: String, completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - DefaultUpdateUserProfileUseCase

class DefaultUpdateUserProfileUseCase: UpdateUserProfileUseCase {
    private let repository: ProfileImageRepository

    init(repository: ProfileImageRepository) {
        self.repository = repository
    }

    /// 프로필 이미지 URL을 가져오는 함수
    func loadProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        repository.loadProfileImage(from: url, completion: completion)
    }

    /// 서버에 프로필 사진을 업데이트하고 그 결과를 반환하는 함수
    func update(from url: String, completion: @escaping (Result<String, Error>) -> Void) {
        // 이미지 데이터를 확인하여 서버에 전송
        repository.uploadProfileImage(payload: url, completion: completion)
    }
}
