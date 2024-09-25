//
//  UserProfileItemModel.swift
//  clean-architecture-seminar
//
//  Created by 최희진 on 9/12/24.
//

import Foundation
import UIKit

// MARK: - UserProfileItemModel

struct UserProfileItemModel: Equatable {
    var username: String
    var name: String
    var imageUrl: String
    var image: UIImage?

    mutating func imageDelete() {
        image = nil
    }

    mutating func imageUpdate(image: UIImage) {
        self.image = image
    }
}

extension UserProfileItemModel {
    init(userData: User) {
        username = userData.username
        name = userData.name
        imageUrl = userData.profileImageUrl
    }
}
