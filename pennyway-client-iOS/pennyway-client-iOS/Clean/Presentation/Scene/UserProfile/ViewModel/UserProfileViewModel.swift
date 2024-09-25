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
    func getUser()
    func uploadPresignedUrl(_ image: UIImage)
    func loadProfileImage(completion: @escaping (Result<UIImage, Error>) -> Void)
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

    private let fetchUserProfileUseCase: FetchUserProfileUseCase
    private let presignedUrlUseCase: PresignedUrlUseCase

    init(fetchUserProfileUseCase: FetchUserProfileUseCase,
         presignedUrlUseCase: PresignedUrlUseCase)
    {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.presignedUrlUseCase = presignedUrlUseCase
        userData = Observable(UserProfileItemModel(
            username: "",
            name: "",
            imageUrl: ""
        ))
    }

    /// usecase를 호출하여 사용자 데이터를 업데이트하는 메서드
    private func getUserData() {
        fetchUserProfileUseCase.execute { result in
            switch result {
            case let .success(userProfile):
                // `userData`를 직접 업데이트
                self.userData.value.imageUrl = userProfile.profileImageUrl
                self.userData.value.username = userProfile.username
                self.userData.value.name = userProfile.name

                Log.debug("[DefaultUserProfileViewModel]-유저정보 조회 \(self.userData)")

            case let .failure(error):
                Log.error("프로필 정보 조회 실패: \(error)")
            }
        }
    }

    /// 프로필 이미지를 업로드하는 메서드
    private func uploadPresignedUrl(image: UIImage) {
        presignedUrlUseCase.generate(type: ImageType.profile.rawValue, ext: Ext.jpeg.rawValue, image: image) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.userData.value.imageUpdate(image: image) // 이미지 업데이트
                    Log.debug("[UserProfileViewModel]-이미지 업데이트 성공")
                }
            case let .failure(error):
                Log.debug("[UserProfileViewModel]-이미지 로드 실패: \(error)")
            }
        }
    }

    /// 업데이트된 사진을 불러오는 함수
    func loadProfileImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        presignedUrlUseCase.loadImage(from: userData.value.imageUrl) { [weak self] result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self?.userData.value.imageUpdate(image: image)
                    completion(.success(image)) // 이미지 로드 성공 시 completion 호출
                }
            case let .failure(error):
                Log.debug("Failed to load image: \(error)")
                completion(.failure(error)) // 이미지 로드 실패 시 completion 호출
            }
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultUserProfileViewModel {
    func getUser() {
        getUserData()
    }

    func uploadPresignedUrl(_ image: UIImage) {
        uploadPresignedUrl(image: image)
    }
}
