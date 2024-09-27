//
//  LogoutViewModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/26/24.
//

import Foundation
import UIKit

// MARK: - LogoutViewModelInput

protocol LogoutViewModelInput {
    func logout()
    func deleteDeviceToken(fcmToken: String)
}

// MARK: - LogoutViewModelOutput

protocol LogoutViewModelOutput {}

// MARK: - LogoutViewModel

protocol LogoutViewModel: LogoutViewModelInput, LogoutViewModelOutput {}

// MARK: - DefaultLogoutViewModel

class DefaultLogoutViewModel: LogoutViewModel {
    var isLoggedOut = false
    private let logoutUseCase: LogoutUseCase

    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
    }

    func logout() {
        logoutUseCase.execute { [weak self] success in
            if success {
                self?.isLoggedOut = true
                Log.debug("[LogoutViewModel]: 로그아웃 성공")
            } else {
                Log.debug("[LogoutViewModel]: 로그아웃 실패")
            }
        }
    }

    func deleteDeviceToken(fcmToken: String) {
        logoutUseCase.deleteDeviceToken(fcmToken: fcmToken) { success in
            if success {
                Log.debug("[LogoutViewModel]: 디바이스 토큰삭제 성공")
            } else {
                Log.error("[LogoutViewModel]: 디바이스 토큰삭제 실패")
            }
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultLogoutViewModel {}
