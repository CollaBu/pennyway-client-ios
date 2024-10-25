//
//  DefaultLogoutRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/26/24.
//

import Foundation

final class DefaultLogoutRepository: LogoutRepository {
    func execute(completion: @escaping (Bool) -> Void) {
        AuthAlamofire.shared.logout { result in
            switch result {
            case let .success(data):
                Log.debug("Success Logout")
                KeychainHelper.deleteAccessToken()
                TokenHandler.deleteAllRefreshTokens()
                completion(true)
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }

                completion(false)
            }
        }
    }

    func deleteDeviceToken(fcmToken: String, completion: @escaping (Bool) -> Void) {
        let fcmTokenDto = FcmTokenDto(token: fcmToken)

        UserAccountAlamofire.shared.deleteDeviceToken(fcmTokenDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ErrorResponseDto.self, from: responseData)
                        Log.debug(response)
                        Log.debug("디바이스 토큰 삭제됨")
                        self.execute { success in
                            if success {
                                Log.debug("로그아웃 성공")
                                completion(true)
                            } else {
                                Log.error("로그아웃 실패.")
                                completion(false)
                            }
                        }

                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):

                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("[UserLogoutViewModel] Failed to verify: \(StatusSpecificError)")

                    if StatusSpecificError.domainError == .notFound && StatusSpecificError.code == NotFoundErrorCode.resourceNotFound.rawValue {
                        // 404에러시 로그아웃 로직 실행
                        self.execute { success in
                            if success {
                                Log.debug("디바이스 토큰 삭제시 404에러 떠서 로그아웃 처리.")
                            } else {
                                Log.error("디바이스 토큰 삭제 못함.")
                            }
                        }
                    } else {
                        Log.error("Failed to verify: \(error)")
                    }
                } else {
                    Log.error("Failed to verify: \(error)")
                }
            }
        }
    }
}
