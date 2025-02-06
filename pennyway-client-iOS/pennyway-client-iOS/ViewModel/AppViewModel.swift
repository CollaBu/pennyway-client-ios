
import AppTrackingTransparency
import Combine
import Firebase
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
        removeUserData()
    }

    func login() {
        registDeviceTokenApi()
        isLoggedIn = true
        requestTrackingPermissionAndInitializeAnalytics()
    }

    func checkLoginStateUseCase() {
        loginUseCase.checkLoginState { [weak self] isLoggedIn in
            if isLoggedIn {
                self?.checkLoginState = isLoggedIn
                self?.isLoggedIn = isLoggedIn
                self?.registDeviceTokenApi()
                Log.debug("[AppViewModel] accessToken: \(KeychainHelper.loadAccessToken())")
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

    /// 앱 추적 권한 요청 및 Firebase Analytics 초기화
    private func requestTrackingPermissionAndInitializeAnalytics() {
        let status = ATTrackingManager.trackingAuthorizationStatus

        if status == .authorized {
            initializeAnalytics() // 추적 허용된 경우 실행
        } else if status == .notDetermined {
            ATTrackingManager.requestTrackingAuthorization { newStatus in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        self.initializeAnalytics()
                    }
                }
            }
        }
    }

    /// Firebase Analytics 초기화
    private func initializeAnalytics() {
        let firebaseAnalyticsService = FirebaseAnalyticsService()
        AnalyticsManager.shared.addService(firebaseAnalyticsService)

        Log.info("📊 Firebase Analytics Initialized")
    }
}
