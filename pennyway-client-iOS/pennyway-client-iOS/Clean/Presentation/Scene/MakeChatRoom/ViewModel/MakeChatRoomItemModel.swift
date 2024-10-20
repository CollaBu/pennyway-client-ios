
import Foundation
import UIKit

// MARK: - MakeChatRoomItemModel

struct MakeChatRoomItemModel: Equatable {
    var title: String
    var description: String
    var password: String
    var backgroundImageUrl: String?
    var image: UIImage?

    mutating func imageDelete() {
        image = nil
    }

    mutating func imageUpdate(image: UIImage) {
        self.image = image
    }

    mutating func backgroundImageUrlUpdate(backgroundImageUrl: String) {
        self.backgroundImageUrl = backgroundImageUrl
    }
}
