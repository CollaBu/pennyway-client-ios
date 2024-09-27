//
//  DeleteUserUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/27/24.
//

import Foundation

protocol DeleteUserUseCase {
    /// 회원탈퇴를 실행하는 함수
    /// - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    func execute(completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultDeleteUserUseCase
class DefaultDeleteUserUseCase: DeleteUserUseCase {
    private let repository: 
    
    func execute(completion: @escaping (Bool) -> Void) {
        <#code#>
    }

}

