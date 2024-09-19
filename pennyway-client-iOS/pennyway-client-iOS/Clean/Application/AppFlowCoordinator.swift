//
//  AppFlowCoordinator.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import SwiftUI

final class AppFlowCoordinator {
    private let appDIContainer: AppDIContainer

    init(
        appDIContainer: AppDIContainer
    ) {
        self.appDIContainer = appDIContainer
    }

    func profileFlowStart() -> any ProfileFactory {
        let profileSceneDIContainer = appDIContainer.makeProfileSceneDIContainer() // ProfileSceneDIContainer
        return profileSceneDIContainer.makeProfileFactory()
    }
}
