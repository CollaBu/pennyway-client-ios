
import Foundation

/// 사용자 프로필 데이터를 가져오는 동작을 정의하는 프로토콜
protocol UserProfileRepository {
    /// 사용자 프로필 데이터를 가져오는 함수
    /// - Returns: `UserModel` 타입의 사용자 프로필 데이터를 반환
    func fetchUserProfile() -> UserModel
}
