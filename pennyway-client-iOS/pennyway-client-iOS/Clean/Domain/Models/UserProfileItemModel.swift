//
//  UserProfileItemModel.swift
//  clean-architecture-seminar
//
//  Created by 최희진 on 9/12/24.
//

import Foundation

// MARK: - UserProfileItemModel

struct UserProfileItemModel: Equatable {
    var username: String
    var name: String
    var profileImageUrl: String
}

extension UserProfileItemModel {
    init(userData: UserModel) {
        username = userData.username
        name = userData.name
        profileImageUrl = userData.profileImageUrl
    }
}
