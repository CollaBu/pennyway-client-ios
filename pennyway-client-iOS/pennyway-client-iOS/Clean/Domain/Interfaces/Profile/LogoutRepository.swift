//
//  LogoutRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/26/24.
//

import Foundation

protocol LogoutRepository {
    /// 로그아웃을 실행하는 함수
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func execute(completion: @escaping (Bool) -> Void)

    /// 디바이스 토큰 제거하는 함수
    func deleteDeviceToken(fcmToken: String, completion: @escaping (Bool) -> Void)
}
