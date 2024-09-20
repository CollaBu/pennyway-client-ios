//
//  ProfileImageRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/20/24.
//

import Foundation

protocol ProfileImageRepository {
    /// 변경된 프로필 이미지 url을 서버에 전송하는 함수
    func updateProfileImageUrl()
}

final class DefaultProfileImageRepository: ProfileImageRepository {
    
    func updateProfileImageUrl() {
        <#code#>
    }
}
