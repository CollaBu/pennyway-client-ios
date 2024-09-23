//
//  ProfileFactory.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import SwiftUI

// MARK: - ProfileFactoryDependency

// TODO: 폴더/파일 네이밍 변경
struct ProfileFactoryDependency: RootDependency {
    // any: ProfileFactory를 준수하는 어떠한 타입이든 profileFactory에 할당될 수 있음
    let profileFactory: any ProfileFactory
}

// MARK: - ProfileFactory

protocol ProfileFactory {
    associatedtype SomeView: View
    func makeProfileView() -> SomeView
}

// MARK: - DefaultProfileFactory

final class DefaultProfileFactory: ProfileFactory {
    private let userProfileViewModelWrapper: UserProfileViewModelWrapper

    init(userProfileViewModelWrapper: UserProfileViewModelWrapper) {
        self.userProfileViewModelWrapper = userProfileViewModelWrapper
    }

    public func makeProfileView() -> some View { // some: "특정 타입만 반환"
        return ProfileView(viewModelWrapper: userProfileViewModelWrapper)
    }
}
