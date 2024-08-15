
import SwiftUI

// MARK: - AppViewModel

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isSplashShown: Bool = false
    @Published var checkLoginState = false

    init() {
        checkLoginStateApi()
    }

    func logout() {
        isLoggedIn = false
        checkLoginState = false
    }

    func login() {
        registDeviceTokenApi()
        isLoggedIn = true
    }
    
    func checkLoginStateApi() {
        UserAuthAlamofire.shared.checkLoginState { [weak self] result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug(response)
                        self?.checkLoginState = true
                        self?.isLoggedIn = true
                        
                        self?.registDeviceTokenApi()
                        Log.debug("accessToken: \(KeychainHelper.loadAccessToken())")
                        
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        self?.checkLoginState = false
                    }
                }
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                
                self?.checkLoginState = false
            }
        }
    }
    
    func registDeviceTokenApi() {
        if let fcmToken = AppDelegate.currentFCMToken {
            let fcmTokenDto = FcmTokenDto(token: fcmToken)
                    
            UserAccountAlamofire.shared.registDeviceToken(fcmTokenDto) { result in
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
        } else {
            Log.fault("fcm Token 존재 x")
        }
    }
}
