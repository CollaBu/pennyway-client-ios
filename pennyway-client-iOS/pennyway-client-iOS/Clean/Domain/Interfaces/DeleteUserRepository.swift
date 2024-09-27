//
//  DeleteUserRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/27/24.
//

import Foundation

protocol DeleteUserRepository {
    /// 사용자 계정을 삭제하는 함수
    func deleteUserAccountApi(completion: @escaping (Bool) -> Void)
}


