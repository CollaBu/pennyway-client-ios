
import SwiftUI

// MARK: - ChatFactoryDependency

struct ChatFactoryDependency: ChatRootDependency {
    let chatFactory: any ChatFactory
}

// MARK: - ChatFactory

protocol ChatFactory {
    associatedtype SomeView: View
    func makeChatView() -> SomeView
}

// MARK: - DefaultChatFactory

final class DefaultChatFactory: ChatFactory {
    private let chatViewModelWrapper: ChatViewModelWrapper
    private let chatRoomViewModelWrapper: ChatRoomViewModelWrapper

    init(chatViewModelWrapper: ChatViewModelWrapper, chatRoomViewModelWrapper: ChatRoomViewModelWrapper) {
        self.chatViewModelWrapper = chatViewModelWrapper
        self.chatRoomViewModelWrapper = chatRoomViewModelWrapper
    }

    public func makeChatView() -> some View { // some: "특정 타입만 반환"
        return ChatCellView(viewModelWrapper: chatViewModelWrapper)
            .environmentObject(chatRoomViewModelWrapper)
    }
}
