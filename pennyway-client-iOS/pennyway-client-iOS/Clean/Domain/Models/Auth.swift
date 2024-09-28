//
//  Auth.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/28/24.
//

import Foundation

struct OAuthLogin: Equatable {
    let oauthId: String
    let idToken: String
    let nonce: String
    let provider: String
}
