//
//  SignUpUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

// MARK: - SignUpUseCase

protocol SignUpUseCase {
    func signUp(model: SignUp, completion: @escaping (Bool, UserId?) -> Void)
    func oauthSignUp(model: OAuthSignUp, completion: @escaping (Bool, UserId?) -> Void)
}

// MARK: - DefaultSignUpUseCase

class DefaultSignUpUseCase: SignUpUseCase {
    private let repository: SignUpRepository
    private let chatStompService = DefaultChatStompService.shared

    init(repository: SignUpRepository) {
        self.repository = repository
    }

    func signUp(model: SignUp, completion: @escaping (Bool, UserId?) -> Void) {
        repository.signUp(model: model) { [weak self] result in
            switch result {
            case let .success(response):
                self?.chatStompService.connect()
                completion(true, UserId(id: Int64(response.user.id)))
            case let .failure(error):
                Log.error("Sign up failed: \(error)")
                completion(false, nil)
            }
        }
    }

    func oauthSignUp(model: OAuthSignUp, completion: @escaping (Bool, UserId?) -> Void) {
        repository.oauthSignUp(model: model) { [weak self] result in
            switch result {
            case let .success(response):
                self?.chatStompService.connect()
                KeychainHelper.deleteOAuthUserData()
                completion(true, UserId(id: Int64(response.user.id)))
            case let .failure(error):
                Log.error("OAuth sign up failed: \(error)")
                completion(false, nil)
            }
        }
    }
}
