
import Foundation
import UIKit

// MARK: - ProfileImageItemModel

struct ProfileImageItemModel: Equatable {
    var profileImageUrl: UIImage?

    mutating func delete() {
        profileImageUrl = nil
    }

    mutating func update(image: UIImage) {
        profileImageUrl = image
    }
}

extension ProfileImageItemModel {
    init(profileImageUrl _: UIImage) {
        profileImageUrl = nil
    }
}
