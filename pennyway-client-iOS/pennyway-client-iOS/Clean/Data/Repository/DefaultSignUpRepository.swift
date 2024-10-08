//
//  DefaultSignUpRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

class DefaultSignUpRepository: SignUpRepository {
    func signUp(model: SignUp, completion: @escaping (Result<AuthResponseDto, Error>) -> Void) {
        let requestDto = SignUpRequestDto.from(model: model)

        AuthAlamofire.shared.signup(requestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        completion(.success(response))
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func oauthSignUp(model: OAuthSignUp, completion: @escaping (Result<AuthResponseDto, Error>) -> Void) {
        let requestDto = OAuthSignUpRequestDto.from(model: model)

        OAuthAlamofire.shared.oauthSignUp(requestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        completion(.success(response))
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
