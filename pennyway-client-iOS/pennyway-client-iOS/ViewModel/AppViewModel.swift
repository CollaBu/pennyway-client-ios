
import Combine
import SwiftUI

// MARK: - AppViewModel

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isSplashShown: Bool = false
    @Published var checkLoginState = false
    let profileInfoViewModel = UserAccountViewModel()

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
            if isLoggedIn {
                self?.profileInfoViewModel.getUserProfileApi { success, userId in
                    if success, let userId = userId {
                        AnalyticsManager.shared.setUser("userId = \(userId)")
                        AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                            AnalyticsConstants.Parameter.oauthType: OAuthRegistrationManager.shared.provider,
                            AnalyticsConstants.Parameter.isRefresh: false,
                        ])
                        self?.checkLoginState = isLoggedIn
                        self?.isLoggedIn = isLoggedIn
                        self?.registDeviceTokenApi()
                        Log.debug("[AppViewModel] accessToken: \(KeychainHelper.loadAccessToken())")
                    }
                }
            }
        }
    }

    func registDeviceTokenApi() {
        if let fcmToken = AppDelegate.currentFCMToken {
            let deviceName = DeviceInfoManager.getDeviceModelName()
            let deviceId = DeviceInfoManager.getDeviceId()
            let deviceInfoDto = DeviceInfoDto(token: fcmToken, deviceId: deviceId, deviceName: deviceName)

            UserAccountAlamofire.shared.registDeviceToken(deviceInfoDto) { result in
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
