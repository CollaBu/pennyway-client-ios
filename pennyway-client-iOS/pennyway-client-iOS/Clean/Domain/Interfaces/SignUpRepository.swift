//
//  SignUpRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

protocol SignUpRepository {
    func signUp(model: SignUp, completion: @escaping (Result<AuthResponseData, Error>) -> Void)
    func oauthSignUp(model: OAuthSignUp, completion: @escaping (Result<AuthResponseData, Error>) -> Void)
}
