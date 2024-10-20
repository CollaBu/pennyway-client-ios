//
//  DefaultLoginRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/25/24.
//

import Foundation

class DefaultLoginRepository: LoginRepository {
    func login(username: String, password: String, completion: @escaping (Result<AuthResponseData, Error>) -> Void) {
        let loginDto = LoginRequestDto(username: username, password: password)
        AuthAlamofire.shared.login(loginDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug("[DefaultLoginRepository] 로그인 성공: \(response)")
                        completion(.success(response.data))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func oauthLogin(model: OAuthLogin, completion: @escaping (Result<AuthResponseData, Error>) -> Void) {
        let requestDto = OAuthLoginRequestDto.from(model: model)

        OAuthAlamofire.shared.oauthLogin(requestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug("[DefaultLoginRepository] 소셜 로그인 성공: \(response)")
                        completion(.success(response.data))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func checkLoginState(completion: @escaping (Result<AuthResponseData, Error>) -> Void) {
        UserAuthAlamofire.shared.checkLoginState { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug("[DefaultLoginRepository] 자동 로그인 성공: \(response)")
                        completion(.success(response.data))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
