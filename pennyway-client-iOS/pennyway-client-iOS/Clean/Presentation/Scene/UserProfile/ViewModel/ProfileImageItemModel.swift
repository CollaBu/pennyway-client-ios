
import Foundation
import UIKit

// MARK: - ProfileImageItemModel

struct ProfileImageItemModel: Equatable {
    var profileImage: UIImage?

    mutating func delete() {
        profileImage = nil
    }

    mutating func update(image: UIImage) {
        profileImage = image
    }
}

//
// extension ProfileImageItemModel {
//    init(profileImageUrl _: UIImage) {
//        profileImageUrl = nil
//    }
// }
