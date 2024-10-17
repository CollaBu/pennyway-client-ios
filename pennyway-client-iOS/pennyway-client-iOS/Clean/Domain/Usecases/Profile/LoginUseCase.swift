
import Foundation

// MARK: - LoginUseCase

protocol LoginUseCase {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void)
    func oauthLogin(data: OAuthLogin, completion: @escaping (Bool, String?) -> Void)
}

// MARK: - DefaultLoginUseCase

class DefaultLoginUseCase: LoginUseCase {
    private let repository: LoginRepository

    init(repository: LoginRepository) {
        self.repository = repository
    }

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        repository.login(username: username, password: password) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    func oauthLogin(data: OAuthLogin, completion: @escaping (Bool, String?) -> Void) {
        repository.oauthLogin(model: data) { result in
            switch result {
            case let .success(response):
                let userId = response.data.user.id
                if userId != -1 {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            case let .failure(error):
                completion(false, error.localizedDescription)
            }
        }
    }
}

