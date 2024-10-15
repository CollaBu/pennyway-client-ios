
import Foundation

// MARK: - MakeChatRoomViewModelInput

protocol MakeChatRoomViewModelInput {
    ///    func makeChatRoom(uuid: String, timestamp: String, ext: String)
    func pendChatRoom(roomData: MakeChatRoomItemModel)
    func validateForm()
}

// MARK: - MakeChatRoomViewModelOutput

protocol MakeChatRoomViewModelOutput {
    var roomData: Observable<MakeChatRoomItemModel> { get set }
    var isFormValid: Bool { get set }
}

// MARK: - MakeChatRoomViewModel

protocol MakeChatRoomViewModel: MakeChatRoomViewModelInput, MakeChatRoomViewModelOutput {}

// MARK: - DefaultMakeChatRoomViewModel

class DefaultMakeChatRoomViewModel: MakeChatRoomViewModel {
    @Published var isFormValid: Bool = false // 버튼 활성화 여부
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

    /// 제목의 유효성 검사 메서드
    func validateForm() {
        let title = roomData.value.title
        isFormValid = !title.isEmpty && title.count <= 30
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
