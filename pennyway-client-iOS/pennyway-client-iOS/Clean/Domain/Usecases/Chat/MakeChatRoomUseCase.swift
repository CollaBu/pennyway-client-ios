//
//  MakeChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/15/24.
//

// MARK: - MakeChatRoomUseCase

/// 채팅방 생성 usecase를 정의하는 프로토콜
protocol MakeChatRoomUseCase {
    /// 채팅방 생성 기능을 하는 함수
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func execute(completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultMakeChatRoomUseCase

class DefaultMakeChatRoomUseCase: MakeChatRoomUseCase {
    
    func execute(completion: @escaping (Bool) -> Void) {
        <#code#>
    }
    

}

