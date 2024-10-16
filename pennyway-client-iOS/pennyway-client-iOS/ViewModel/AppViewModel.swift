
import Combine
import SwiftUI

// MARK: - AppViewModel

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isSplashShown: Bool = false
    @Published var checkLoginState = false

    private var cancellables = Set<AnyCancellable>()
    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase = DefaultLoginUseCase(repository: DefaultLoginRepository())) {
        self.loginUseCase = loginUseCase
        checkLoginStateUseCase()

        // Combine을 사용하여 NotificationCenter 알림 구독
        NotificationCenter.default.publisher(for: .logoutNotification)
            .sink { [weak self] _ in
                self?.logout()
            }
            .store(in: &cancellables)
    }

    func logout() {
        isLoggedIn = false
        checkLoginState = false
    }

    func login() {
        registDeviceTokenApi()
        isLoggedIn = true
    }

    func checkLoginStateUseCase() {
        loginUseCase.checkLoginState { [weak self] isLoggedIn in
            self?.checkLoginState = isLoggedIn
            self?.isLoggedIn = isLoggedIn
            if isLoggedIn {
                self?.registDeviceTokenApi()
                Log.debug("accessToken: \(KeychainHelper.loadAccessToken())")
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
