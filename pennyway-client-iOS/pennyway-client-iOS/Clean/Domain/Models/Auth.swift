//
//  Auth.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

// MARK: - OAuthLogin

struct OAuthLogin: Equatable {
    let oauthId: String
    let idToken: String
    let nonce: String
    let provider: String
}

// MARK: - SignUp

struct SignUp: Equatable {
    let name: String
    let username: String
    let password: String
    let phone: String
    let code: String
}

// MARK: - OAuthSignUp

struct OAuthSignUp: Equatable {
    let oauthId: String
    let idToken: String
    let nonce: String
    let name: String
    let username: String
    let phone: String
    let code: String
    let provider: String
}
