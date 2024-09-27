//
//  DefaultDeleteUserRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/27/24.
//

import Foundation

final class DefaultDeleteUserAccountRepository: DeleteUserAccountRepository {
    func deleteUserAccount(completion: @escaping (Bool) -> Void) { UserAccountAlamofire.shared.deleteUserAccount { result in
        switch result {
        case .success:
            Log.debug("[DefaultDeleteUserAccountRepository]:사용자 계정 삭제 완료")
            KeychainHelper.deleteAccessToken()
            TokenHandler.deleteAllRefreshTokens()
            completion(true)
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
            } else {
                Log.error("Network request failed: \(error)")
            }
            completion(false)
        }
    }
    }
}
