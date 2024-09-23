//
//  DefaultUserProfileRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import Foundation

class DefaultUserProfileRepository: FetchUserProfileRepository {
    func fetchUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        if let userData = getUserData() {
            let profileResponseDTO = ProfileResponseDTO(
                id: userData.id,
                username: userData.username,
                name: userData.name,
                isGeneralSignUp: userData.isGeneralSignUp,
                passwordUpdatedAt: userData.passwordUpdatedAt ?? "",
                profileImageUrl: userData.profileImageUrl,
                phone: userData.phone,
                profileVisibility: userData.profileVisibility,
                locked: userData.locked,
                notifySetting: NotifySettingDTO(accountBookNotify: userData.notifySetting.accountBookNotify, feedNotify: userData.notifySetting.feedNotify, chatNotify: userData.notifySetting.chatNotify),
                createdAt: userData.createdAt,
                oauthAccount: OAuthAccountDTO(kakao: userData.oauthAccount.kakao, google: userData.oauthAccount.google, apple: userData.oauthAccount.apple))

            completion(.success(profileResponseDTO.toModel()))
        } else {
            completion(.failure(StatusError.notFound))
        }
    }
}
