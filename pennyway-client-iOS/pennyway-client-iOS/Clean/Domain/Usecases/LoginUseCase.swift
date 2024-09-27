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

                completion(true)

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
                let userId = response.data.user.id
                if userId != -1 {
                    completion(true, nil) // Pass userId back to the view
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
