//
//  SignUpRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

protocol SignUpRepository {
    func signUp(_ signupDto: SignUpRequestDto, completion: @escaping (Result<AuthResponseDto, Error>) -> Void)
    func oauthSignUp(_ oauthSignUpDto: OAuthSignUpRequestDto, completion: @escaping (Result<AuthResponseDto, Error>) -> Void)
}
