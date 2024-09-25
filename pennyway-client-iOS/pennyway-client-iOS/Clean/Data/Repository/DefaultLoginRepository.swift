//
//  DefaultLoginRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/25/24.
//

import Foundation

class DefaultLoginRepository: LoginRepository {
    func login(username: String, password: String, completion: @escaping (Result<AuthResponseDto, Error>) -> Void) {
        let loginDto = LoginRequestDto(username: username, password: password)
        AuthAlamofire.shared.login(loginDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        completion(.success(response))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func oauthLogin(dto: OAuthLoginRequestDto, completion: @escaping (Result<AuthResponseDto, Error>) -> Void) {
        OAuthAlamofire.shared.oauthLogin(dto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        completion(.success(response))
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
