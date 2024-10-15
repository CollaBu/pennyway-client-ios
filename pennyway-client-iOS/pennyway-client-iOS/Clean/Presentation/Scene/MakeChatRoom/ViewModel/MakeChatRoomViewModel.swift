
import Foundation

// MARK: - MakeChatRoomViewModelInput

protocol MakeChatRoomViewModelInput {
    ///    func makeChatRoom(uuid: String, timestamp: String, ext: String)
    func pendChatRoom(roomData: MakeChatRoomItemModel)
}

// MARK: - MakeChatRoomViewModelOutput

protocol MakeChatRoomViewModelOutput {
    var roomData: Observable<MakeChatRoomItemModel> { get set }
}

// MARK: - MakeChatRoomViewModel

protocol MakeChatRoomViewModel: MakeChatRoomViewModelInput, MakeChatRoomViewModelOutput {}

// MARK: - DefaultMakeChatRoomViewModel

class DefaultMakeChatRoomViewModel: MakeChatRoomViewModel {
    var roomData: Observable<MakeChatRoomItemModel>

    private let makeChatRoomUseCase: MakeChatRoomUseCase

    init(makeChatRoomUseCase: MakeChatRoomUseCase) {
        self.makeChatRoomUseCase = makeChatRoomUseCase

        roomData = Observable(MakeChatRoomItemModel(
            title: "",
            description: "",
            password: 0

        ))
    }

    func pendChatRoom(roomData: MakeChatRoomItemModel) {
        makeChatRoomUseCase.pend(roomData: roomData) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(chatRoomId):
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 생성 대기 성공")
                case let .failure(error):
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 생성 대기 실패")
                }
            }
        }
    }
}
