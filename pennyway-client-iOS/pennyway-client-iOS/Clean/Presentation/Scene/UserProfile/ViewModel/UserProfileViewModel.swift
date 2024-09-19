//
//  UserProfileViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import Foundation

// MARK: - UserProfileViewModelInput

protocol UserProfileViewModelInput {
    func viewDidLoad()
    func updateData(_ newName: String)
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

    init(fetchUserProfileUseCase: FetchUserProfileUseCase) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
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

    /// 이름을 업데이트하는 메서드
    private func updateName(_ newName: String) {
        Log.debug("Updated name to \(newName)")
        Log.debug("Updated \(userData.value)")
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
