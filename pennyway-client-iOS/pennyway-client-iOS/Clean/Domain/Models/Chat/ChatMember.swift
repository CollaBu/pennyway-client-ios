//
//  ChatMember.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import Foundation

// MARK: - ChatMember

struct ChatMember: Equatable, Identifiable {
    let id: Int64
    let userId: Int64
    let name: String
    let role: Role
    let notifyEnabled: Bool
    let createdAt: String
    let profileImage: String?
}


// MARK: - OtherMember

struct OtherMember: Equatable, Identifiable {
    let id: Int64
    let name: String
}
