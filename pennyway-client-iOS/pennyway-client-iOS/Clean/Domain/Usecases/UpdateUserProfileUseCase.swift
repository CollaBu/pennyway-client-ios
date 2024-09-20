//
//  UpdateUserProfileUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/20/24.
//

import Foundation

/// 사용자 프로필사진을 변경하여 서버에 바뀐 사진을 전송하는 usecase를 정의하는 프로토콜
protocol UpdateProfileImageUseCase {
    /// 변경된 프로필 사진을 서버에 전송하는 함수
    /// - Returns: `String` 타입의 업데이트된 사용자 프로필 데이터를 반환.
    func update() -> String
}

class DefaultUpdateUserProfileUseCase: UpdateProfileImageUseCase {
    
    private let repository: ProfileImageRepository

    init(repository: ProfileImageRepository) {
        self.repository = repository
    }
    
    func update() -> String {
        <#code#>
    }
    
}
