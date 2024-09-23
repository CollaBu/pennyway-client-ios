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

    private func makeDeleteProfileUseCase() -> DeleteUserProfileUseCase {
        DefaultDeleteUserProfileUseCase(repository: makeProfileRepository())
    }

    private func makeUpdateProfileUseCase() -> UpdateUserProfileUseCase {
        DefaultUpdateUserProfileUseCase(repository: makeProfileRepository())
    }

    // MARK: - Repository

    private func makeProfileRepository() -> UserProfileRepository {
        DefaultUserProfileRepository()
    }

    private func makeProfileRepository() -> ProfileImageRepository {
        DefaultProfileImageRepository()
    }

    // MARK: - View Model

    private func makeProfileViewModel() -> any UserProfileViewModel {
        DefaultUserProfileViewModel(
            fetchUserProfileUseCase: makeProfileUseCase(),
            deleteUserProfileUseCase: makeDeleteProfileUseCase(), 
            updateUserProfileUseCase: makeUpdateProfileUseCase())
    }

    // MARK: - View Model Wrapper

    private func makeUserProfileViewModelWrapper() -> UserProfileViewModelWrapper {
        UserProfileViewModelWrapper(
            viewModel: makeProfileViewModel())
    }
}
