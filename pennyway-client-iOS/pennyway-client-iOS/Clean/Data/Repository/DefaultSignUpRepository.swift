//
//  DefaultSignUpRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

class DefaultSignUpRepository: SignUpRepository {
    func signUp(_ signupDto: SignUpRequestDto, completion: @escaping (Result<AuthResponseDto, Error>) -> Void) {
        AuthAlamofire.shared.signup(signupDto) { result in
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

    func oauthSignUp(_ oauthSignUpDto: OAuthSignUpRequestDto, completion: @escaping (Result<AuthResponseDto, Error>) -> Void) {
        OAuthAlamofire.shared.oauthSignUp(oauthSignUpDto) { result in
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
