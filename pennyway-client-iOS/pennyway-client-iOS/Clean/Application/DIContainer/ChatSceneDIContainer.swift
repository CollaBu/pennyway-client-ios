
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
        return DefaultChatFactory(chatViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases

    private func makeChatRoomUseCase() -> MakeChatRoomUseCase {
        let presignedUrlRepository = profileSceneDIContainer.makePresignedUrlRepository()

        return DefaultMakeChatRoomUseCase(repository: makeChatRoomRepository(), 
                                          urlRepository: presignedUrlRepository)
    }

    // MARK: - Repository

    func makeChatRoomRepository() -> MakeChatRoomRepository {
        DefaultMakeChatRoomRepository()
    }

    func makePresignedUrlRepository() -> PresignedUrlRepository {
        DefaultPresignedUrlRepository()
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

    // MARK: - View Model Wrapper

    private func makeChatViewModelWrapper() -> ChatViewModelWrapper {
        return ChatViewModelWrapper(makeChatViewModel: makeChatRoomViewModel())
    }
}
