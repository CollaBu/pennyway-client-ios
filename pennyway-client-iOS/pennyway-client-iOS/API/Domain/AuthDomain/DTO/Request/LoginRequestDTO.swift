//
//  LoginRequestDTO.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 4/16/24.
//

import Foundation


public struct LoginRequestDTO: Encodable {
    let username: String
    let password: String
    
    public init(
        username: String,
        password: String
    ) {
        self.username = username
        self.password = password
    }
}
