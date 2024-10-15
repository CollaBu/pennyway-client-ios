
import SwiftUI

struct ChatMainView: View {
    private let chatFactory: any ChatFactory

    init(chatFactory: any ChatFactory) {
        self.chatFactory = chatFactory
    }

    var body: some View {
        Group {
            chatFactory.makeChatView()
                .wrapAnyView()
        }
    }
}
