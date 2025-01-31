//
//  EditChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

import Combine
import Foundation
import UIKit

// MARK: - EditChatRoomViewModelInput

protocol EditChatRoomViewModelInput {
    func uploadImage(image: UIImage)
    func getChatAdminMode(chatRoomId: Int64, completion: @escaping (Result<AdminModeChatRoomItemModel, Error>) -> Void)
    func editChatRoom(completion: @escaping (Bool) -> Void)
    func updateEditRoomData(title: String, description: String, password: String, selectedUIImage: UIImage?)
    func handleChatRoomAlarm(chatRoomId: Int64, chatRoomAlarm: ChatRoomAlarmType, completion: @escaping (Bool) -> Void)
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
    private var isUploadingImage = false
    private var pendingEditChatRoomRequest: (() -> Void)?

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

    func updateEditRoomData(title: String, description: String, password: String, selectedUIImage: UIImage?) {
        if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            editRoomData.value.title = title
        }
        if !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            editRoomData.value.description = description
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

    /// Presigned URL 생성 및 이미지 업로드
    func uploadImage(image: UIImage) {
        guard !isUploadingImage else {
            return
        }

        isUploadingImage = true
        editChatRoomUseCase.uploadImage(roomData: editRoomData.value, image: image) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.isUploadingImage = false

                switch result {
                case let .success(url):
                    self.editRoomData.value.backgroundImageUrl = url
                    Log.debug("[EditChatRoomViewModel]: 채팅방 이미지 업로드 성공, URL: \(url)")

                    // 대기 중인 editChatRoom 요청이 있다면 실행
                    self.pendingEditChatRoomRequest?()
                    self.pendingEditChatRoomRequest = nil

                case let .failure(error):
                    Log.fault("[EditChatRoomViewModel]: 채팅방 이미지 업로드 실패, 오류: \(error)")
                }
            }
        }
    }

    /// 채팅방 수정 확정 요청
    func editChatRoom(completion: @escaping (Bool) -> Void) {
        // 이미지 업로드 중이면 대기열에 등록 후 종료
        if isUploadingImage {
            Log.debug("[EditChatRoomViewModel]: 이미지 업로드 중, 채팅방 수정 요청 대기")
            pendingEditChatRoomRequest = { [weak self] in
                self?.executeEditChatRoom(completion: completion)
            }
            return
        }

        // 즉시 실행
        executeEditChatRoom(completion: completion)
    }

    /// 채팅방 알람 설정 요청
    func handleChatRoomAlarm(chatRoomId: Int64, chatRoomAlarm: ChatRoomAlarmType, completion: @escaping (Bool) -> Void) {
        editChatRoomUseCase.handleChatRoomAlarm(chatRoomId: chatRoomId, chatRoomAlarm: chatRoomAlarm, completion: completion)
    }
}

extension DefaultEditChatRoomViewModel {
    /// 채팅방 수정 실행 (공통 메서드)
    private func executeEditChatRoom(completion: @escaping (Bool) -> Void) {
        editChatRoomUseCase.editChatRoom(roomData: editRoomData.value) { success in
            DispatchQueue.main.async {
                Log.debug("[EditChatRoomViewModel]: 채팅방 수정 \(success ? "성공" : "실패")")
                completion(success)
            }
        }
    }
}
