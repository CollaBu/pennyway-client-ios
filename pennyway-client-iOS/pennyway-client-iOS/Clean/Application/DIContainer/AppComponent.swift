//
//  AppComponent.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import SwiftUI

final class AppComponent {
    private let appDIContainer = AppDIContainer()

    /// Lazy로 appFlowCoordinator를 선언하여 appDIContainer가 먼저 초기화된 후에 생성되도록 함
    private lazy var appFlowCoordinator: AppFlowCoordinator = {
        AppFlowCoordinator(appDIContainer: appDIContainer)
    }()

    func makeRootView() -> some View {
        let profileFactory = appFlowCoordinator.profileFlowStart() // DefaultProfileFactory에 wrapper 주입 성공
        return rootComponent(profileFactory: profileFactory).makeView()
    }

    private func rootComponent(profileFactory: any ProfileFactory) -> RootComponent {
        RootComponent(dependency: ProfileFactoryDependency(profileFactory: profileFactory))
    }
}
