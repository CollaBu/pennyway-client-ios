
import Foundation
import UIKit

// MARK: - MakeChatRoomViewModelInput

protocol MakeChatRoomViewModelInput {
    func validateForm()
    func uploadImage(image: UIImage)
    func makeChatRoom()
}

// MARK: - MakeChatRoomViewModelOutput

protocol MakeChatRoomViewModelOutput {
    var roomData: Observable<MakeChatRoomItemModel> { get set }
    var isFormValid: Bool { get set }
    var isDismissView: Bool { get set }
}

// MARK: - MakeChatRoomViewModel

protocol MakeChatRoomViewModel: MakeChatRoomViewModelInput, MakeChatRoomViewModelOutput {}

// MARK: - DefaultMakeChatRoomViewModel

class DefaultMakeChatRoomViewModel: MakeChatRoomViewModel {
    @Published var isFormValid: Bool = false // 버튼 활성화 여부
    @Published var isDismissView: Bool = false // 뷰를 닫는 상태 여부
    var roomData: Observable<MakeChatRoomItemModel>

    private let makeChatRoomUseCase: MakeChatRoomUseCase
    private let presignedUrlUseCase: PresignedUrlUseCase

    init(makeChatRoomUseCase: MakeChatRoomUseCase, presignedUrlUseCase: PresignedUrlUseCase) {
        self.makeChatRoomUseCase = makeChatRoomUseCase
        self.presignedUrlUseCase = presignedUrlUseCase

        roomData = Observable(MakeChatRoomItemModel(
            title: "",
            description: "",
            password: "",
            backgroundImageUrl: ""

        ))
    }

    /// 제목의 유효성 검사 메서드
    func validateForm() {
        let title = roomData.value.title
        isFormValid = !title.isEmpty && title.count <= 30
    }

    /// Presigned URL 생성
    func uploadImage(image: UIImage) {
        // UseCase를 통해 이미지 업로드 후 채팅방 생성 확정 요청
        makeChatRoomUseCase.uploadImage(roomData: roomData.value, image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(url):
                    self?.roomData.value.backgroundImageUrl = url
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 이미지 업로드 성공, URL: \(url)")

                case let .failure(error):
                    Log.fault("[MakeChatRoomViewModel]: 채팅방 이미지 업로드 실패, 오류: \(error)")
                }
            }
        }
    }

    /// 채팅방 생성 확정 요청
    func makeChatRoom() {
        makeChatRoomUseCase.makeChatRoom(roomData: roomData.value) { [weak self] success in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                if success {
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 생성 확정 성공")
                    self.isDismissView = true // 값이 변경되는지 확인
                    Log.debug("isDismissView = \(self.isDismissView)")
                } else {
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 생성 확정 실패")
                }
            }
        }
    }
}
