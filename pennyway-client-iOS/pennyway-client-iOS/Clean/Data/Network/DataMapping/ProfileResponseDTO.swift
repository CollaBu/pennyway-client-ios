//
//  ProfileResponseDTO.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import Foundation

// MARK: - ProfileResponseDTO

struct ProfileResponseDTO: Decodable {
    let id: Int64
    let username: String
    let name: String
    let isGeneralSignUp: Bool
    let passwordUpdatedAt: String
    let profileImageUrl: String
    let phone: String
    let profileVisibility: String
    let locked: Bool
    let notifySetting: NotifySettingDTO
    let createdAt: String
    let oauthAccount: OAuthAccountDTO
}

// MARK: - NotifySettingDTO

struct NotifySettingDTO: Decodable {
    let accountBookNotify: Bool
    let feedNotify: Bool
    let chatNotify: Bool
}

// MARK: - OAuthAccountDTO

struct OAuthAccountDTO: Decodable {
    let kakao: Bool
    let google: Bool
    let apple: Bool
}

extension ProfileResponseDTO {
    func toModel() -> User {
        return .init(id: id, username: username, name: name, isGeneralSignUp: isGeneralSignUp, passwordUpdatedAt: passwordUpdatedAt, profileImageUrl: profileImageUrl, phone: phone, profileVisibility: profileVisibility, locked: locked, notifySetting: NotifySettingDTO.toModel(notifySetting)(), createdAt: createdAt, oauthAccount: OAuthAccountDTO.toModel(oauthAccount)())
    }
}

extension NotifySettingDTO {
    func toModel() -> NotifySetting {
        return .init(accountBookNotify: accountBookNotify, feedNotify: feedNotify, chatNotify: chatNotify)
    }
}

extension OAuthAccountDTO {
    func toModel() -> OAuthAccount {
        return .init(kakao: kakao, google: google, apple: apple)
    }
}
