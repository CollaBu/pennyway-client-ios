//
//  LogoutUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/26/24.
//

import Foundation

// MARK: - LogoutUseCase

/// 사용자 로그아웃 동작을하는 usecase를 정의하는 프로토콜
protocol LogoutUseCase {
    /// 로그아웃을 실행하는 함수
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func execute(completion: @escaping (Bool) -> Void)

    /// 디바이스 토큰 삭제하는 함수
    /// - Parameters:
    ///   - fcmToken: 사용자의 fcmToken
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func deleteDeviceToken(fcmToken: String, completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultLogoutUseCase

class DefaultLogoutUseCase: LogoutUseCase {
    private let repository: LogoutRepository

    init(repository: LogoutRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Bool) -> Void) {
        repository.execute(completion: completion)
    }

    func deleteDeviceToken(fcmToken: String, completion: @escaping (Bool) -> Void) {
        repository.deleteDeviceToken(fcmToken: fcmToken) { success in
            completion(success)
        }
    }
}
