//
//  ProfileSceneDIContainer.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import SwiftUI

final class ProfileSceneDIContainer {
//    struct Dependencies {
//        let apiDataTransferService: DataTransferService
//    }
//    
//    private let dependencies: Dependencies
//
//    init(dependencies: Dependencies) {
//        self.dependencies = dependencies
//    }

    // MARK: - Factory

    func makeProfileFactory() -> DefaultProfileFactory { // DefaultProfileFactory를 생성하여 반환
        let viewModelWrapper = makeUserProfileViewModelWrapper()
        return DefaultProfileFactory(userProfileViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases

    private func makeProfileUseCase() -> FetchUserProfileUseCase {
        DefaultFetchUserProfileUseCase(repository: makeProfileRepository())
    }

    private func makePresignedUrlUseCase() -> PresignedUrlUseCase {
        DefaultPresignedUrlUseCase(urlRepository: makePresignedUrlRepository(),
                                   imageRepository: makeProfileImageRepository()
        )
    }

    private func makeDeleteImageUseCase() -> DeleteImageUseCase {
        DefaultDeleteImageUseCase(repository: makeProfileImageRepository())
    }

    private func makeLogoutUseCase() -> LogoutUseCase {
        DefaultLogoutUseCase(repository: makeLogoutRepository())
    }

    // MARK: - Repository

    private func makeProfileRepository() -> FetchUserProfileRepository {
        DefaultUserProfileRepository()
    }

    private func makePresignedUrlRepository() -> PresignedUrlRepository {
        DefaultPresignedUrlRepository()
    }

    private func makeProfileImageRepository() -> ProfileImageRepository {
        DefaultProfileImageRepository()
    }

    private func makeLogoutRepository() -> LogoutRepository {
        DefaultLogoutRepository()
    }

    // MARK: - View Model

    private func makeProfileViewModel() -> any UserProfileViewModel {
        DefaultUserProfileViewModel(
            fetchUserProfileUseCase: makeProfileUseCase(),
            presignedUrlUseCase: makePresignedUrlUseCase(),
            deleteImageUseCase: makeDeleteImageUseCase()
        )
    }

    private func makeLogoutViewModel() -> any LogoutViewModel {
        DefaultLogoutViewModel(
            logoutUseCase: makeLogoutUseCase()
        )
    }

    // MARK: - View Model Wrapper

    private func makeUserProfileViewModelWrapper() -> UserProfileViewModelWrapper {
        UserProfileViewModelWrapper(
            viewModel: makeProfileViewModel(),
            logoutViewModel: makeLogoutViewModel()
        )
    }
}
