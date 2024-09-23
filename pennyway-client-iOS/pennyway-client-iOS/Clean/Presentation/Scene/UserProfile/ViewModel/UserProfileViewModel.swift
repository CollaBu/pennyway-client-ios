//
//  UserProfileViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import Foundation
import UIKit

// MARK: - UserProfileViewModelInput

protocol UserProfileViewModelInput {
    func viewDidLoad()
    func updateData(_ newName: String)
    func updateProfileImage(from url: String)
}

// MARK: - UserProfileViewModelOutput

protocol UserProfileViewModelOutput {
    var userData: Observable<UserProfileItemModel> { get }
}

// MARK: - UserProfileViewModel

protocol UserProfileViewModel: UserProfileViewModelInput, UserProfileViewModelOutput {}

// MARK: - DefaultUserProfileViewModel

class DefaultUserProfileViewModel: UserProfileViewModel {
    var userData: Observable<UserProfileItemModel>
    @Published var profileImageUrl: UIImage?

    private let fetchUserProfileUseCase: FetchUserProfileUseCase // 유저 정보 조회
    private let deleteUserProfileUseCase: DeleteUserProfileUseCase // 사용자 프로필 삭제
    private let updateUserProfileUseCase: UpdateUserProfileUseCase // 업데이트된 이미지를 서버에 전달
    // presingned url
    // profileIamge
    // deleteProfileImage

    init(fetchUserProfileUseCase: FetchUserProfileUseCase, deleteUserProfileUseCase: DeleteUserProfileUseCase, updateUserProfileUseCase: UpdateUserProfileUseCase) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.deleteUserProfileUseCase = deleteUserProfileUseCase
        self.updateUserProfileUseCase = updateUserProfileUseCase

        userData = Observable(UserProfileItemModel(
            username: "",
            name: "기본",
            profileImageUrl: ""
        ))
    }

    /// usecase를 호출하여 사용자 데이터를 업데이트하는 메서드
    private func updateUserData() {
        userData.value.username = fetchUserProfileUseCase.execute().username
        userData.value.name = fetchUserProfileUseCase.execute().name

        Log.debug(userData.value)
    }

    /// 이름을 업데이트하는 메서드
    private func updateName(_ newName: String) {
        Log.debug("Updated name to \(newName)")
        Log.debug("Updated \(userData.value)")
    }

    /// 업데이트 된 사진을 서버에 전달하는 함수
    func updateProfileImage(from url: String) {
        // URL을 통해 이미지를 불러옵니다.
        loadProfileImage(from: url) { [weak self] result in
            switch result {
            case let .success(image):
                // 이미지를 성공적으로 불러온 경우
                DispatchQueue.main.async {
                    self?.profileImageUrl = image // 프로필 이미지 업데이트

                    // 서버에 URL 전송
                    self?.updateUserProfileUseCase.update(from: url) { result in
                        switch result {
                        case let .success(response):
                            Log.debug("프로필 이미지가 성공적으로 업데이트되었습니다: \(response)")
                        case let .failure(error):
                            Log.debug("프로필 이미지 업데이트 실패: \(error)")
                        }
                    }
                }
            case let .failure(error):
                Log.debug("이미지 로드 실패: \(error)")
            }
        }
    }

    /// 업데이트된 사진을 불러오는 함수
    func loadProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        updateUserProfileUseCase.loadProfileImage(from: url) { [weak self] result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self?.profileImageUrl = image
                    completion(.success(image))
                }
            case let .failure(error):
                Log.debug("Failed to load image: \(error)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultUserProfileViewModel {
    func viewDidLoad() {
        updateUserData()
    }

    func updateData(_ newName: String) {
        updateName(newName)
    }
}
