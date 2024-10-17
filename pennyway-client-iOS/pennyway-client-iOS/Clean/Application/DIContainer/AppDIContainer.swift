//
//  AppDIContainer.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import Foundation

final class AppDIContainer {
//    lazy var appConfiguration = AppConfiguration()

//    // MARK: - Network
//    lazy var apiDataTransferService: DataTransferService = {
//        return DefaultDataTransferService()
//    }()

    // MARK: - DIContainers of scenes

    // TODO: 수정필요
    func makeProfileSceneDIContainer() -> ProfileSceneDIContainer {
//        let dependencies = ProfileSceneDIContainer.Dependencies(
//            apiDataTransferService: apiDataTransferService
//        )
        return ProfileSceneDIContainer()
    }

    func makeChatSceneDIContainer() -> ChatSceneDIContainer {
        return ChatSceneDIContainer(profileSceneDIContainer: makeProfileSceneDIContainer())
    }
}
