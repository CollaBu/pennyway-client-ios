
import os.log
import SwiftUI

class UserLogoutViewModel: ObservableObject {
    @Published var isLoggedOut = false

    func logout(completion: @escaping (Bool) -> Void) {
        AuthAlamofire.shared.logout { result in
            switch result {
            case let .success(data):

                self.isLoggedOut = true
                Log.debug("Success Logout")
                KeychainHelper.deleteAccessToken()
                TokenHandler.deleteAllRefreshTokens()

                if let fcmToken = AppDelegate.currentFCMToken {
                    self.deleteDeviceTokenApi(fcmToken: fcmToken)
                } else {
                    Log.debug("FCM token이 존재하지 않음")
                }

                completion(true)

            case let .failure(error):

                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    Log.info("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    Log.error("Failed to verify: \(error)")
                }
                completion(false)
            }
        }
    }

    func deleteDeviceTokenApi(fcmToken: String) {
        let fcmTokenDto = FcmTokenDto(token: fcmToken)

        UserAccountAlamofire.shared.deleteDeviceToken(fcmTokenDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ErrorResponseDto.self, from: responseData)
                        Log.debug(response)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }
}
