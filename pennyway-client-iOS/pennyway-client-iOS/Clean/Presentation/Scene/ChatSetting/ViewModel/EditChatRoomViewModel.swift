//
//  EditChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

import Foundation

//
//  ChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Combine
import Foundation
import UIKit

// MARK: - EditChatRoomViewModelInput

protocol EditChatRoomViewModelInput {
    func uploadImage(image: UIImage)
    func editChatRoom(completion: @escaping (Bool) -> Void)
    func updateEditRoomData(title: String, password: String)
}

// MARK: - EditChatRoomViewModelOutput

protocol EditChatRoomViewModelOutput {
    var editRoomData: Observable<EditChatRoomItemModel> { get set }
}

// MARK: - EditChatRoomViewModel

protocol EditChatRoomViewModel: EditChatRoomViewModelInput, EditChatRoomViewModelOutput {}

// MARK: - DefaultEditChatRoomViewModel

class DefaultEditChatRoomViewModel: EditChatRoomViewModel {
    var isFormValid: Bool = false
    var editRoomData: Observable<EditChatRoomItemModel>

    private let editChatRoomUseCase: EditChatRoomUseCase

    init(editChatRoomUseCase: EditChatRoomUseCase) {
        self.editChatRoomUseCase = editChatRoomUseCase

        editRoomData = Observable(EditChatRoomItemModel(
            chatRoomId: 0,
            title: "",
            description: "",
            password: "",
            backgroundImageUrl: ""
        ))
    }

    func updateEditRoomData(title: String, password: String) {
        if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            editRoomData.value.title = title
        }
        editRoomData.value.password = password
    }

    /// Presigned URL 생성
    func uploadImage(image: UIImage) {
        // UseCase를 통해 이미지 업로드 후 채팅방 수정 확정 요청
        editChatRoomUseCase.uploadImage(roomData: editRoomData.value, image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(url):
                    self?.editRoomData.value.backgroundImageUrl = url
                    Log.debug("[EditChatRoomViewModel]: 채팅방 이미지 업로드 성공, URL: \(url)")

                case let .failure(error):
                    Log.fault("[EditChatRoomViewModel]: 채팅방 이미지 업로드 실패, 오류: \(error)")
                }
            }
        }
    }

    /// 채팅방 수정 확정 요청
    func editChatRoom(completion: @escaping (Bool) -> Void) {
        editChatRoomUseCase.editChatRoom(roomData: editRoomData.value) { success in
            DispatchQueue.main.async {
                if success {
                    Log.debug("[EditChatRoomViewModel]: 채팅방 수정 확정 성공")
                    completion(true)
                } else {
                    Log.debug("[EditChatRoomViewModel]: 채팅방 수정 확정 실패")
                    completion(false)
                }
            }
        }
    }
}
