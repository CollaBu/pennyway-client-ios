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
            imageUrl: "",
            username: "",
            name: ""
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

            case let .failure(error):
                Log.error("프로필 정보 조회 실패: \(error)")
            }
        }
    }

    /// 프로필 이미지를 업로드하는 메서드
    private func uploadPresignedUrl(image: UIImage) {
        presignedUrlUseCase.generate(type: ImageType.profile.rawValue, ext: Ext.jpeg.rawValue, image: image)
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
