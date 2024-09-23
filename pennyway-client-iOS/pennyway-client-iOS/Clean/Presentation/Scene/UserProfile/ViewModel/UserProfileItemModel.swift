//
//  UserProfileItemModel.swift
//  clean-architecture-seminar
//
//  Created by 최희진 on 9/12/24.
//

import Foundation

// MARK: - UserProfileItemModel

struct UserProfileItemModel: Equatable {
    var imageUrl: String
    var username: String
    var name: String
}

extension UserProfileItemModel {
    init(userData: User) {
        imageUrl = userData.profileImageUrl
        username = userData.username
        name = userData.name
    }
}
