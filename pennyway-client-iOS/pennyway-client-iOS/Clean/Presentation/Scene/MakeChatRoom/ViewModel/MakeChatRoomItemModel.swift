
import Foundation
import UIKit

// MARK: - MakeChatRoomItemModel

struct MakeChatRoomItemModel: Equatable {
    var title: String
    var description: String
    var password: Int32
    var backgroundImageUrl: String?
    var image: UIImage?

    mutating func imageDelete() {
        image = nil
    }

    mutating func imageUpdate(image: UIImage) {
        self.image = image
    }
}
