//
//  SignUpUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

// MARK: - SignUpUseCase

protocol SignUpUseCase {
    func signUp(_ signupDto: SignUpRequestDto, completion: @escaping (Bool, UserId?) -> Void)
    func oauthSignUp(_ oauthSignUpDto: OAuthSignUpRequestDto, completion: @escaping (Bool, UserId?) -> Void)
}

// MARK: - DefaultSignUpUseCase

class DefaultSignUpUseCase: SignUpUseCase {
    private let repository: SignUpRepository

    init(repository: SignUpRepository) {
        self.repository = repository
    }

    func signUp(_ signupDto: SignUpRequestDto, completion: @escaping (Bool, UserId?) -> Void) {
        repository.signUp(signupDto) { result in
            switch result {
            case let .success(response):
                completion(true, UserId(id: Int64(response.data.user.id)))
            case let .failure(error):
                Log.error("Sign up failed: \(error)")
                completion(false, nil)
            }
        }
    }

    func oauthSignUp(_ oauthSignUpDto: OAuthSignUpRequestDto, completion: @escaping (Bool, UserId?) -> Void) {
        repository.oauthSignUp(oauthSignUpDto) { result in
            switch result {
            case let .success(response):
                KeychainHelper.deleteOAuthUserData()
                completion(true, UserId(id: Int64(response.data.user.id)))
            case let .failure(error):
                Log.error("OAuth sign up failed: \(error)")
                completion(false, nil)
            }
        }
    }
}
