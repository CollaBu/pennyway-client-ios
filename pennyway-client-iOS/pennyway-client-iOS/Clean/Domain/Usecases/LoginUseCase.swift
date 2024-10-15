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
}

// MARK: - DefaultLoginUseCase

class DefaultLoginUseCase: LoginUseCase {
    private let repository: LoginRepository
    private let chatRepository: ChatServerRepository

    init(repository: LoginRepository, chatRepository: ChatServerRepository) {
        self.repository = repository
        self.chatRepository = chatRepository
    }

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        repository.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.getChatServer { chatResult in
                    switch chatResult {
                    case .success:
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
            case .failure:
                completion(false)
            }
        }
    }

    func oauthLogin(data: OAuthLogin, completion: @escaping (Bool, String?) -> Void) {
        repository.oauthLogin(model: data) { [weak self] result in
            switch result {
            case let .success(response):
                let userId = response.data.user.id
                if userId != -1 {
                    self?.getChatServer { chatResult in
                        switch chatResult {
                        case .success:
                            completion(true, nil)
                        case let .failure(error):
                            completion(false, error.localizedDescription)
                        }
                    }
                } else {
                    completion(false, nil)
                }
            case let .failure(error):
                completion(false, error.localizedDescription)
            }
        }
    }

    private func getChatServer(completion: @escaping (Result<Void, Error>) -> Void) {
        chatRepository.getChatServer { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
