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
