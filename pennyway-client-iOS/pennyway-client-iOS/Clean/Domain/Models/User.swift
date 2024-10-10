//
//  User.swift
//  clean-architecture-seminar
//
//  Created by 최희진 on 9/4/24.
//

import Foundation

// MARK: - User

struct User: Equatable {
    let id: Int64
    let username: String
    let name: String
    let isGeneralSignUp: Bool
    let passwordUpdatedAt: String
    let profileImageUrl: String
    let phone: String
    let profileVisibility: String
    let locked: Bool
    let notifySetting: NotifySetting
    let createdAt: String
    let oauthAccount: OAuthAccount
}

// MARK: - NotifySetting

struct NotifySetting: Equatable {
    let accountBookNotify: Bool
    let feedNotify: Bool
    let chatNotify: Bool
}

// MARK: - OAuthAccount

struct OAuthAccount: Equatable {
    let kakao: Bool
    let google: Bool
    let apple: Bool
}

// MARK: - UserId

struct UserId: Equatable {
    let id: Int64
}
