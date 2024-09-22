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
    private let generatePresignedUrlUseCase: GeneratePresignedUrlUseCase
    private let storePresignedUrlUseCase: StorePresignedUrlUseCase

    init(fetchUserProfileUseCase: FetchUserProfileUseCase,
         generatePresignedUrlUseCase: GeneratePresignedUrlUseCase,
         storePresignedUrlUseCase: StorePresignedUrlUseCase)
    {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.generatePresignedUrlUseCase = generatePresignedUrlUseCase
        self.storePresignedUrlUseCase = storePresignedUrlUseCase
        userData = Observable(UserProfileItemModel(
            username: "",
            name: "기본"
        ))
    }

    /// usecase를 호출하여 사용자 데이터를 업데이트하는 메서드
    private func updateUserData() {
        userData.value.username = fetchUserProfileUseCase.execute().username
        userData.value.name = fetchUserProfileUseCase.execute().name

        Log.debug(userData.value)
    }

    /// 프로필 이미지를 업로드하는 메서드
    private func uploadPresignedUrl(image: UIImage) {
        // Presigned URL 생성
        generatePresignedUrlUseCase.execute(type: ImageType.profile.rawValue, ext: Ext.jpeg.rawValue) { [weak self] result in
            switch result {
            case let .success(presignedUrl):
                Log.debug("Presigned URL 생성 성공: \(presignedUrl.presignedUrl)")

                // Presigned URL을 사용하여 이미지 업로드
                self?.storePresignedUrlUseCase.execute(presignedUrl: presignedUrl.presignedUrl, image: image) { result in
                    switch result {
                    case .success:
                        Log.debug("이미지 업로드 성공")
                    case let .failure(error):
                        Log.error("이미지 업로드 실패: \(error)")
                    }
                }
            case let .failure(error):
                Log.error("Presigned URL 생성 실패: \(error)")
            }
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultUserProfileViewModel {
    func viewDidLoad() {
        updateUserData()
    }

    func uploadPresignedUrl(_ image: UIImage) {
        uploadPresignedUrl(image: image)
    }
}
