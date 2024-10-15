
import SwiftUI

// MARK: - ChatRootDependency

protocol ChatRootDependency {
    var chatFactory: any ChatFactory { get }
}

// MARK: - ChatRootComponent

final class ChatRootComponent {
    private let chatDependency: ChatRootDependency

    init(chatDependency: ChatRootDependency) {
        self.chatDependency = chatDependency
    }

    func makeChatView() -> some View {
        ChatMainView(
            chatFactory: chatDependency.chatFactory
        )
    }
}
