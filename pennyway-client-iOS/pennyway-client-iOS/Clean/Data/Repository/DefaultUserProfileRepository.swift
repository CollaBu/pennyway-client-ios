
import Foundation

class DefaultUserProfileRepository: UserProfileRepository {
    func fetchUserProfile() -> UserModel {
        // ProfileResponseDTO 초기 데이터를 설정
        let profileResponseDTO = ProfileResponseDTO(
            id: 1,
            username: "user1",
            name: "홍길동",
            isGeneralSignUp: false,
            passwordUpdatedAt: "2023-09-04 12:00:00",
            profileImageUrl: "https://example.com/profile.jpg",
            phone: "010-1234-5678",
            profileVisibility: "PUBLIC",
            locked: false,
            notifySetting: NotifySettingDTO(accountBookNotify: true, feedNotify: true, chatNotify: true),
            createdAt: "2023-09-04 12:00:00",
            oauthAccount: OAuthAccountDTO(kakao: true, google: false, apple: false)
        )
        // 생성자 매개변수 너무 많다? -> 빌더 패턴 써라

        // toModel()을 호출하여 UserModel로 변환 후 반환
        return profileResponseDTO.toModel()
    }
}
