//
//  LoginRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/25/24.
//

import Foundation

protocol LoginRepository {
    func login(username: String, password: String, completion: @escaping (Result<AuthResponseDto, Error>) -> Void)
    func oauthLogin(model: OAuthLogin, completion: @escaping (Result<AuthResponseDto, Error>) -> Void)
    func checkLoginState(completion: @escaping (Result<AuthResponseDto, Error>) -> Void)
}
