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
    func getChatAdminMode(chatRoomId: Int64, completion: @escaping (Result<AdminModeChatRoomItemModel, Error>) -> Void)
    func editChatRoom(completion: @escaping (Bool) -> Void)
    func updateEditRoomData(title: String, password: String, selectedUIImage: UIImage?)
}

// MARK: - EditChatRoomViewModelOutput

protocol EditChatRoomViewModelOutput {
    var editRoomData: Observable<AdminModeChatRoomItemModel> { get set }
}

// MARK: - EditChatRoomViewModel

protocol EditChatRoomViewModel: EditChatRoomViewModelInput, EditChatRoomViewModelOutput {}

// MARK: - DefaultEditChatRoomViewModel

class DefaultEditChatRoomViewModel: EditChatRoomViewModel {
    var isFormValid: Bool = false
    var editRoomData: Observable<AdminModeChatRoomItemModel>

    private let editChatRoomUseCase: EditChatRoomUseCase

    init(editChatRoomUseCase: EditChatRoomUseCase) {
        self.editChatRoomUseCase = editChatRoomUseCase

        editRoomData = Observable(AdminModeChatRoomItemModel(
            chatRoomId: 0,
            title: "",
            description: nil,
            password: nil,
            backgroundImageUrl: nil
        ))
    }

    func updateEditRoomData(title: String, password: String, selectedUIImage: UIImage?) {
        if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            editRoomData.value.title = title
        }
        if selectedUIImage == nil {
            editRoomData.value.backgroundImageUrlUpdate(backgroundImageUrl: nil)
        }
        editRoomData.value.password = password
    }

    func getChatAdminMode(chatRoomId: Int64, completion: @escaping (Result<AdminModeChatRoomItemModel, Error>) -> Void) {
        editChatRoomUseCase.getChatAdminMode(chatRoomId: chatRoomId) { [weak self] result in
            switch result {
            case let .success(response):

                let adminModeChatRoomItemModel = AdminModeChatRoom.to(model: response)
                self?.editRoomData.value = adminModeChatRoomItemModel

                Log.debug("[EditChatRoomViewModel]: 채팅방 관리자 모드 조회 성공, URL: \(response)")
                completion(.success(adminModeChatRoomItemModel))

            case let .failure(error):
                Log.fault("[EditChatRoomViewModel]: 채팅방 관리자 모드 조회 실패, 오류: \(error)")
                completion(.failure(error))
            }
        }
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
