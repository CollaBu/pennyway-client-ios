//
//  MainChatUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/8/24.
//

import Foundation

protocol MainChatUseCase {
    /// 사용자 채팅방을 조회하는 함수
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func execute(completion: @escaping (Bool) -> Void)
}
