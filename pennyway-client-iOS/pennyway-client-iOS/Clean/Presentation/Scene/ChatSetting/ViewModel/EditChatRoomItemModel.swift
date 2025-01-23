//
//  EditChatRoomItemModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

import Foundation
import UIKit

// MARK: - EditChatRoomItemModel

struct EditChatRoomItemModel: Equatable {
    var chatRoomId: Int64
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
