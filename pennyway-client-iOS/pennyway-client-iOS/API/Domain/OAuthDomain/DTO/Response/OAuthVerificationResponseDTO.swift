//
//  OAuthVerificationResponseDTO.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 4/17/24.
//

import Foundation

// MARK: - OAuthVerificationResponseDTO

struct OAuthVerificationResponseDTO: Codable {
    let code: String
    let data: OAuthVerificationResponseData
}

// MARK: - OAuthVerificationResponseData

struct OAuthVerificationResponseData: Codable {
    let sms: OAuthVerificationResponseDetails
}

// MARK: - OAuthVerificationResponseDetails

struct OAuthVerificationResponseDetails: Codable {
    let code: Bool
    let existsUser: Bool
    let username: String
}
