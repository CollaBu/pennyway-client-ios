//
//  UserModel.swift
//  clean-architecture-seminar
//
//  Created by 최희진 on 9/4/24.
//

import Foundation

// MARK: - UserModel

struct UserModel: Equatable {
    let id: Int64
    let username: String
    let name: String
    let isGeneralSignUp: Bool
    let passwordUpdatedAt: String
    let profileImageUrl: String
    let phone: String
    let profileVisibility: String
    let locked: Bool
    let notifySetting: NotifySettingModel
    let createdAt: String
    let oauthAccount: OAuthAccountModel
}

// MARK: - NotifySettingModel

struct NotifySettingModel: Equatable {
    let accountBookNotify: Bool
    let feedNotify: Bool
    let chatNotify: Bool
}

// MARK: - OAuthAccountModel

struct OAuthAccountModel: Equatable {
    let kakao: Bool
    let google: Bool
    let apple: Bool
}
