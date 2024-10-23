//
//  ProfileSceneDIContainer.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import SwiftUI

final class ProfileSceneDIContainer {
    // MARK: - Factory

    func makeProfileFactory() -> DefaultProfileFactory { // DefaultProfileFactory를 생성하여 반환
        let viewModelWrapper = makeUserProfileViewModelWrapper()
        return DefaultProfileFactory(userProfileViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases

    private func makeProfileUseCase() -> FetchUserProfileUseCase {
        DefaultFetchUserProfileUseCase(repository: makeProfileRepository())
    }

    func makePresignedUrlUseCase() -> PresignedUrlUseCase {
        return DefaultPresignedUrlUseCase(urlRepository: makePresignedUrlRepository(),
                                          imageRepository: makeProfileImageRepository())
    }

    private func makeDeleteImageUseCase() -> DeleteImageUseCase {
        DefaultDeleteImageUseCase(repository: makeProfileImageRepository())
    }

    private func makeLogoutUseCase() -> LogoutUseCase {
        DefaultLogoutUseCase(repository: makeLogoutRepository())
    }

    private func makeDeleteUserUseCase() -> DeleteUserAccountUseCase {
        DefaultDeleteUserAccountUseCase(repository: makeDeleteUserRepository())
    }

    // MARK: - Repository

    private func makeProfileRepository() -> FetchUserProfileRepository {
        DefaultUserProfileRepository()
    }

    func makePresignedUrlRepository() -> PresignedUrlRepository {
        DefaultPresignedUrlRepository()
    }

    private func makeProfileImageRepository() -> ProfileImageRepository {
        DefaultProfileImageRepository()
    }

    private func makeLogoutRepository() -> LogoutRepository {
        DefaultLogoutRepository()
    }

    private func makeDeleteUserRepository() -> DeleteUserAccountRepository {
        DefaultDeleteUserAccountRepository()
    }

    // MARK: - View Model

    func makeProfileViewModel() -> any UserProfileViewModel {
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

    private func makeDeleteUserAccountViewModel() -> any DeleteUserViewModel {
        DefaultDeleteUserViewModel(deleteUseCase: makeDeleteUserUseCase())
    }

    // MARK: - View Model Wrapper

    func makeUserProfileViewModelWrapper() -> UserProfileViewModelWrapper {
        UserProfileViewModelWrapper(
            viewModel: makeProfileViewModel(),
            logoutViewModel: makeLogoutViewModel(),
            deleteUserViewModel: makeDeleteUserAccountViewModel()
        )
    }
}
