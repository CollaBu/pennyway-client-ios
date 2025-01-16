
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

    // MARK: - Chat View Model Wrapper

    private func makeChatViewModelWrapper() -> ChatViewModelWrapper {
        return ChatViewModelWrapper(makeChatViewModel: makeChatRoomViewModel(), getChatRoomViewModel: makeGetChatRoomViewModel(), chatRoomViewModel: makeChatRoomDetailViewModel(), joinChatRoomViewModel: makeJoinChatRoomViewModel())
    }

    // - Chat Use Cases

    private func makeChatRoomUseCase() -> MakeChatRoomUseCase {
        let presignedUrlRepository = profileSceneDIContainer.makePresignedUrlRepository()

        return DefaultMakeChatRoomUseCase(repository: makeChatRoomRepository(), 
                                          urlRepository: presignedUrlRepository)
    }

    private func makeGetChatRoomUseCase() -> GetChatRoomUseCase {
        return DefaultGetChatRoomUseCase(repository: makeGetChatRoomRepository())
    }

    private func makeSearchChatRoomUseCase() -> SearchChatRoomUseCase {
        return DefaultSearchChatRoomUseCase(searchChatRoomRepository: makeSearchChatRoomRepository())
    }

    private func makeJoinChatRoomUseCase() -> JoinChatRoomUseCase {
        return DefaultJoinChatRoomUseCase(repository: makeJoinChatRoomRepository())
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

    private func makeSearchChatRoomRepository() -> SearchChatRoomRepository {
        DefaultSearchChatRoomRepository()
    }

    private func makeJoinChatRoomRepository() -> JoinChatRoomRepository {
        DefaultJoinChatRoomRepository()
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
        return DefaultGetChatRoomViewModel(getChatRoomUseCase: makeGetChatRoomUseCase(), searchChatRoomUseCase: makeSearchChatRoomUseCase())
    }

    private func makeJoinChatRoomViewModel() -> JoinChatRoomViewModel {
        return DefaultJoinChatRoomViewModel(joinChatRoomUseCase: makeJoinChatRoomUseCase())
    }

//    // MARK: - View Model Wrapper
//
//    private func makeChatViewModelWrapper() -> ChatViewModelWrapper {
//        return ChatViewModelWrapper(makeChatViewModel: makeChatRoomViewModel(), getChatRoomViewModel: makeGetChatRoomViewModel(), chatRoomViewModel: makeChatRoomViewModel(), joinChatRoomViewModel: makeJoinChatRoomViewModel())
//    }
//

    // MARK: - Chat Room View Model Wrapper

    private func makeChatRoomViewModelWrapper() -> ChatRoomViewModelWrapper {
        return ChatRoomViewModelWrapper(chatRoomViewModel: makeChatRoomDetailViewModel())
    }

    // - Chat Room Use Cases

    private func makeGetChatUseCase() -> GetChatUseCase {
        return DefaultGetChatUseCase(repository: makeGetChatRepository())
    }

    private func makeSendChatUseCase() -> SendChatUseCase {
        return DefaultSendChatUseCase()
    }

    private func makeEditChatRoomUseCase() -> EditChatRoomUseCase {
        let presignedUrlRepository = profileSceneDIContainer.makePresignedUrlRepository()
        return DefaultEditChatRoomUseCase(repository: makeEdittChatRoomRepository(), urlRepository: presignedUrlRepository)
    }

    // - Chat Room Repository

    func makeGetChatRepository() -> GetChatRepository {
        DefaultGetChatRepository()
    }

    func makeEdittChatRoomRepository() -> EditChatRoomRepository {
        DefaultEditChatRoomRepository()
    }

    // - Chat Room View Model

    private func makeChatRoomDetailViewModel() -> ChatRoomViewModel {
        return DefaultChatRoomViewModel(chatRoomUseCase: makeGetChatUseCase(), editChatRoomUseCase: makeEditChatRoomUseCase(), sendChatUseCase: makeSendChatUseCase())
    }
}
