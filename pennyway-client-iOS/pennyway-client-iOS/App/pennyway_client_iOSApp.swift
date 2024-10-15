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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as! String
        KakaoSDK.initSDK(appKey: kakaoAppKey, loggingEnable: false)
    }

    var body: some Scene {
        WindowGroup {
            if appViewModel.isLoggedIn || appViewModel.checkLoginState {
                LayoutView {
                    MainTabView()
                        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                        .onOpenURL { url in
                            GIDSignIn.sharedInstance.handle(url)
                        }
                }
                .environmentObject(appViewModel)
                .environmentObject(networkStatus)
            } else {
                if appViewModel.isSplashShown {
                    LayoutView {
                        LoginView()
                            .onOpenURL { url in
                                GIDSignIn.sharedInstance.handle(url)
                            }
                    }
                    .environmentObject(appViewModel)
                    .environmentObject(networkStatus)

                } else {
                    LayoutView {
                        MainView()
                            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                            .onOpenURL { url in
                                GIDSignIn.sharedInstance.handle(url)
                            }
                    }
                    .environmentObject(appViewModel)
                    .environmentObject(networkStatus)
                }
            }
        }
    }
}
