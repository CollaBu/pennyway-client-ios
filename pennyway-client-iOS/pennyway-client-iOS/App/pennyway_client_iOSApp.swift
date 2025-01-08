import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SwiftUI

// MARK: - pennyway_client_iOSApp

@main
struct pennyway_client_iOSApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var networkStatus = NetworkStatusViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewStateManager = ViewStateManager() // view 상태 감지

    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as! String
        KakaoSDK.initSDK(appKey: kakaoAppKey, loggingEnable: false)
    }

    var body: some Scene {
        WindowGroup {
            LayoutView {
                if appViewModel.isLoggedIn || appViewModel.checkLoginState {
                    MainTabView()
                } else {
                    if appViewModel.isSplashShown {
                        LoginView()
                    } else {
                        MainView()
                    }
                }
            }
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            .onAppear {
                // 사용 예시
                let secretKey = "exampleSecretKeyForSpringBootProjectAtSubRepository"
                let expirationTimeMs: Int64 = 5 * 60 * 1000 // 5분

                let generator = AccessTokenGenerator(secretKey: secretKey, expirationTimeMs: expirationTimeMs)
                do {
                    let token = try generator.generateToken(userId: 1, role: "ROLE_USER")
                    print("📍📍📍 Generated Token:", token)
                } catch {
                    print("Error:", error)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .onChange(of: scenePhase) { newPhase in
                viewStateManager.setScenePhase(newPhase)
            }
            .environmentObject(appViewModel)
            .environmentObject(networkStatus)
            .environmentObject(viewStateManager)
        }
    }
}
