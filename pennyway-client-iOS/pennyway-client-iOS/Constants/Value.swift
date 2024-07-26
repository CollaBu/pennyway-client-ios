//
//  Value.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 5/31/24.
//

import Foundation

// MARK: - MaxValue

enum MaxValue {
    static let maxValue: Int = 2_147_483_647
}

// MARK: - VerificationType

enum VerificationType: String {
    case general = "GENERAL"
    case oauth = "OAUTH"
    case username = "USERNAME"
    case password = "PASSWORD"
    case phone = "PHONE"
}
