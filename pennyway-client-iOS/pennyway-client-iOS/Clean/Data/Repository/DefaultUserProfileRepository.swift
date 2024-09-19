//
//  DefaultUserProfileRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import Foundation

class DefaultUserProfileRepository: FetchUserProfileProtocol {
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

        // toModel()을 호출하여 UserModel로 변환 후 반환
        return profileResponseDTO.toModel()
    }
}
