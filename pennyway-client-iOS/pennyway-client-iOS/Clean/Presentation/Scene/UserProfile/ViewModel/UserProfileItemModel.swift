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
}

extension UserProfileItemModel {
    init(userData: User) {
        username = userData.username
        name = userData.name
    }
}
