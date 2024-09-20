//
//  FetchUserProfileProtocol.swift
//  clean-architecture-seminar
//
//  Created by 최희진 on 9/5/24.
//

import Foundation

/// 사용자 프로필 데이터를 가져오는 동작을 정의하는 프로토콜
protocol FetchUserProfileProtocol {
    /// 사용자 프로필 데이터를 가져오는 함수
    /// - Returns: `UserModel` 타입의 사용자 프로필 데이터를 반환
    func fetchUserProfile() -> UserModel

    /// 사용자 프로필을 삭제하는 함수
    /// - Returns: 사용자 기본 정보 presignedUrl에 빈값을 넣어주기 위해 `String` 타입을 반환
    func deleteUserProfile() -> String
}
