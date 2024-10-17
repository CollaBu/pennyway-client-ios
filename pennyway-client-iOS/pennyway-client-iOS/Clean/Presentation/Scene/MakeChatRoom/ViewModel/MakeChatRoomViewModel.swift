
import Foundation
import UIKit

// MARK: - MakeChatRoomViewModelInput

protocol MakeChatRoomViewModelInput {
    func validateForm()
    func createChatRoomWithImage(image: UIImage)
}

// MARK: - MakeChatRoomViewModelOutput

protocol MakeChatRoomViewModelOutput {
    var roomData: Observable<MakeChatRoomItemModel> { get set }
    var isFormValid: Bool { get set }
    var chatRoomId: Int64? { get set }
}

// MARK: - MakeChatRoomViewModel

protocol MakeChatRoomViewModel: MakeChatRoomViewModelInput, MakeChatRoomViewModelOutput {}

// MARK: - DefaultMakeChatRoomViewModel

class DefaultMakeChatRoomViewModel: MakeChatRoomViewModel {
    @Published var isFormValid: Bool = false // 버튼 활성화 여부
    @Published var chatRoomId: Int64?
    var roomData: Observable<MakeChatRoomItemModel>

    private let makeChatRoomUseCase: MakeChatRoomUseCase
    private let presignedUrlUseCase: PresignedUrlUseCase

    init(makeChatRoomUseCase: MakeChatRoomUseCase, presignedUrlUseCase: PresignedUrlUseCase) {
        self.makeChatRoomUseCase = makeChatRoomUseCase
        self.presignedUrlUseCase = presignedUrlUseCase

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

    /// Presigned URL 생성 후 채팅방 생성 확정 요청
    func createChatRoomWithImage(image: UIImage) {
        // UseCase를 통해 이미지 업로드 후 채팅방 생성 확정 요청
        makeChatRoomUseCase.createChatRoomWithImage(roomData: roomData.value, image: image) { success in
            DispatchQueue.main.async {
                if success {
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 생성 확정 성공")
                } else {
                    Log.fault("[MakeChatRoomViewModel]: 채팅방 생성 확정 실패")
                }
            }
        }
    }
}
