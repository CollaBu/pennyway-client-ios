import Combine
import Foundation
import UIKit

// MARK: - MakeChatRoomViewModelInput

protocol MakeChatRoomViewModelInput {
    func validateForm()
    func uploadImage(image: UIImage)
    func makeChatRoom(completion: @escaping (Bool) -> Void)
}

// MARK: - MakeChatRoomViewModelOutput

protocol MakeChatRoomViewModelOutput {
    var roomData: Observable<MakeChatRoomItemModel> { get set }
    var isFormValid: Bool { get set }
    var isDismissView: Bool { get set }
    var isPrivate: Bool { get set }
}

// MARK: - MakeChatRoomViewModel

protocol MakeChatRoomViewModel: MakeChatRoomViewModelInput, MakeChatRoomViewModelOutput {}

// MARK: - DefaultMakeChatRoomViewModel

class DefaultMakeChatRoomViewModel: MakeChatRoomViewModel, ObservableObject {
    @Published var isFormValid: Bool = false // 버튼 활성화 여부
    @Published var isDismissView: Bool = false // 뷰를 닫는 상태 여부
    @Published var isPrivate: Bool = false // 공개 범위 설정 상태
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
        let isTitleValid = !title.isEmpty && title.count <= 30
        let isPasswordValid = roomData.value.password.count == 6
        // 1. 제목이 유효하고
        // 2-1. 비공개방이 아니거나(isPrivate = false)
        // 2-2. 비공개방이면서(isPrivate = true) 비밀번호가 유효한 경우(password.count == 6)
        if isPrivate {
            isFormValid = isTitleValid && isPasswordValid
        } else {
            isFormValid = isTitleValid
        }
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
    func makeChatRoom(completion: @escaping (Bool) -> Void) {
        makeChatRoomUseCase.makeChatRoom(roomData: roomData.value) { [weak self] success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if success {
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 생성 확정 성공")
                    self?.isDismissView = true // 값이 변경되는지 확인
                    Log.debug("isDismissView = \(self?.isDismissView)")
                    completion(true)
                } else {
                    Log.debug("[MakeChatRoomViewModel]: 채팅방 생성 확정 실패")
                    completion(false)
                }
            }
        }
    }
}
