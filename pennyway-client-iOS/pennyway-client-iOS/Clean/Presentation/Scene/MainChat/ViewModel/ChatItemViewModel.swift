
import Foundation
import SwiftUI

struct ChatItemViewModel: Equatable {
    var chatRoomTitle: String

    init(chatRoomTitle: String) {
        self.chatRoomTitle = chatRoomTitle
    }
}
