//
//  LoginUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/25/24.
//

import Foundation

class LoginUseCase {
    private let repository: LoginRepository
    private let profileInfoViewModel = UserAccountViewModel()

    init(repository: LoginRepository) {
        self.repository = repository
    }

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        repository.login(username: username, password: password) { result in
            switch result {
            case let .success(response):
                self.profileInfoViewModel.getUserProfileApi { _ in
                    AnalyticsManager.shared.setUser("userId = \(response.data.user.id)")
                    AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                        AnalyticsConstants.Parameter.oauthType: "none",
                        AnalyticsConstants.Parameter.isRefresh: false
                    ])
                    completion(true)
                }
            case let .failure(error):
                print("Login failed: \(error)")
                completion(false)
            }
        }
    }

    func oauthLogin(dto: OAuthLoginRequestDto, completion: @escaping (Bool, String?) -> Void) {
        repository.oauthLogin(dto: dto) { result in
            switch result {
            case let .success(response):
                let isOAuthExistUser = response.data.user.id
                if isOAuthExistUser != -1 {
                    self.profileInfoViewModel.getUserProfileApi { _ in
                        KeychainHelper.deleteOAuthUserData()
                        AnalyticsManager.shared.setUser("userId = \(response.data.user.id)")
                        AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                            AnalyticsConstants.Parameter.oauthType: dto.provider,
                            AnalyticsConstants.Parameter.isRefresh: false
                        ])
                        completion(true, nil)
                    }
                } else {
                    completion(false, nil)
                }
            case let .failure(error):
                print("OAuth login failed: \(error)")
                completion(false, error.localizedDescription)
            }
        }
    }
}
