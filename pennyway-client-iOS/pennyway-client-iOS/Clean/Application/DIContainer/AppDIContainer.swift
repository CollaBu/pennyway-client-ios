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

    func makeProfileSceneDIContainer() -> ProfileSceneDIContainer {
//        let dependencies = ProfileSceneDIContainer.Dependencies(
//            apiDataTransferService: apiDataTransferService
//        )
        return ProfileSceneDIContainer()
    }

    func makeChatSceneDIContainer() -> ChatSceneDIContainer {
//        let dependencies = ProfileSceneDIContainer.Dependencies(
//            apiDataTransferService: apiDataTransferService
//        )
        return ChatSceneDIContainer()
    }
}
