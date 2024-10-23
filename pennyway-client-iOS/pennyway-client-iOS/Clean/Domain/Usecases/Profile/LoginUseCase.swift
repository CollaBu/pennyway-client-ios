//
//  LoginUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/25/24.
//

import Foundation

// MARK: - LoginUseCase

protocol LoginUseCase {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void)
    func oauthLogin(data: OAuthLogin, completion: @escaping (Bool, String?) -> Void)
    func linkOAuthToAccount(data: LinkOAuthToAccount, completion: @escaping (Bool, String?) -> Void)
    func linkAccountToOAuth(data: LinkAccountToOAuth, completion: @escaping (Bool, String?) -> Void)
    func checkLoginState(completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultLoginUseCase

class DefaultLoginUseCase: LoginUseCase {
    private let repository: LoginRepository
    private let chatStompService = DefaultChatStompService.shared

    init(repository: LoginRepository) {
        self.repository = repository
    }

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        repository.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.chatStompService.connect()
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    func oauthLogin(data: OAuthLogin, completion: @escaping (Bool, String?) -> Void) {
        repository.oauthLogin(model: data) { [weak self] result in
            switch result {
            case let .success(response):
                let userId = response.user.id
                if userId != -1 {
                    self?.chatStompService.connect()
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            case let .failure(error):
                completion(false, error.localizedDescription)
            }
        }
    }

    func checkLoginState(completion: @escaping (Bool) -> Void) {
        repository.checkLoginState { [weak self] result in
            switch result {
            case .success:
                self?.chatStompService.connect()
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    func linkOAuthToAccount(data: LinkOAuthToAccount, completion: @escaping (Bool, String?) -> Void) {
        repository.linkOAuthToAccount(model: data) { [weak self] result in
            switch result {
            case let .success(responseData):
                self?.chatStompService.connect()
                completion(true, String(responseData.user.id))
            case .failure:
                completion(false, nil)
            }
        }
    }

    func linkAccountToOAuth(data: LinkAccountToOAuth, completion: @escaping (Bool, String?) -> Void) {
        repository.linkAccountToOAuth(model: data) { [weak self] result in
            switch result {
            case let .success(responseData):
                self?.chatStompService.connect()
                completion(true, String(responseData.user.id))
            case let .failure(error):
                completion(false, nil)
            }
        }
    }
}
