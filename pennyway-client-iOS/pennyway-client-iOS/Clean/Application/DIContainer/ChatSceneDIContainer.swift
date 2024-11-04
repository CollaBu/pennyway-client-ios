
import SwiftUI

final class ChatSceneDIContainer {
    private let profileSceneDIContainer: ProfileSceneDIContainer

    /// ChatSceneDIContainer의 초기화 시 ProfileSceneDIContainer를 주입
    init(profileSceneDIContainer: ProfileSceneDIContainer) {
        self.profileSceneDIContainer = profileSceneDIContainer
    }

    // MARK: - Factory

    func makeChatFactory() -> DefaultChatFactory {
        let viewModelWrapper = makeChatViewModelWrapper()
        let chatRoomViewModelWrapper = makeChatRoomViewModelWrapper()
        return DefaultChatFactory(chatViewModelWrapper: viewModelWrapper, chatRoomViewModelWrapper: chatRoomViewModelWrapper)
    }

    // MARK: - Use Cases

    private func makeChatRoomUseCase() -> MakeChatRoomUseCase {
        let presignedUrlRepository = profileSceneDIContainer.makePresignedUrlRepository()

        return DefaultMakeChatRoomUseCase(repository: makeChatRoomRepository(), 
                                          urlRepository: presignedUrlRepository)
    }

    private func makeGetChatRoomUseCase() -> GetChatRoomUseCase {
        return DefaultGetChatRoomUseCase(repository: makeGetChatRoomRepository())
    }

    private func makeChatRoomUseCase() -> ChatRoomUseCase {
        return DefaultChatRoomUseCase(repository: makeChatRoomDetailRepository())
    }

    // MARK: - Repository

    func makeChatRoomRepository() -> MakeChatRoomRepository {
        DefaultMakeChatRoomRepository()
    }

    func makePresignedUrlRepository() -> PresignedUrlRepository {
        DefaultPresignedUrlRepository()
    }

    func makeGetChatRoomRepository() -> GetChatRoomRepository {
        DefaultGetChatRoomRepository()
    }

    func makeChatRoomDetailRepository() -> ChatRoomRepository {
        DefaultChatRoomRepository()
    }

    // MARK: - View Model

    private func makeChatRoomViewModel() -> MakeChatRoomViewModel {
        let presignedUrlUseCase = profileSceneDIContainer.makePresignedUrlUseCase()

        // ViewModel 인스턴스를 생성하고 반환
        return DefaultMakeChatRoomViewModel(
            makeChatRoomUseCase: makeChatRoomUseCase(),
            presignedUrlUseCase: presignedUrlUseCase
        )
    }

    private func makeGetChatRoomViewModel() -> GetChatRoomViewModel {
        return DefaultGetChatRoomViewModel(getChatRoomUseCase: makeGetChatRoomUseCase())
    }

    private func makeChatRoomViewModel() -> ChatRoomViewModel {
        return DefaultChatRoomViewModel(chatRoomUseCase: makeChatRoomUseCase())
    }

    // MARK: - View Model Wrapper

    private func makeChatViewModelWrapper() -> ChatViewModelWrapper {
        return ChatViewModelWrapper(makeChatViewModel: makeChatRoomViewModel(), getChatRoomViewModel: makeGetChatRoomViewModel(), chatRoomViewModel: makeChatRoomViewModel())
    }

    private func makeChatRoomViewModelWrapper() -> ChatRoomViewModelWrapper {
        return ChatRoomViewModelWrapper(chatRoomViewModel: makeChatRoomViewModel())
    }
}
