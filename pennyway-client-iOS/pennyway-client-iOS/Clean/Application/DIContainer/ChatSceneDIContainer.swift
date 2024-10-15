
import SwiftUI

final class ChatSceneDIContainer {
    // MARK: - Factory

    func makeChatFactory() -> DefaultChatFactory {
        let viewModelWrapper = makeChatViewModelWrapper()
        return DefaultChatFactory(chatViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases

    private func makeChatRoomUseCase() -> MakeChatRoomUseCase {
        DefaultMakeChatRoomUseCase(repository: makeChatRoomRepository())
    }

    // MARK: - Repository

    private func makeChatRoomRepository() -> MakeChatRoomRepository {
        DefaultMakeChatRoomRepository()
    }

    // MARK: - View Model

    private func makeChatRoomViewModel() -> MakeChatRoomViewModel {
        DefaultMakeChatRoomViewModel(makeChatRoomUseCase: makeChatRoomUseCase())
    }

    // MARK: - View Model Wrapper

    private func makeChatViewModelWrapper() -> ChatViewModelWrapper {
        ChatViewModelWrapper(makeChatViewModel: makeChatRoomViewModel())
    }
}
