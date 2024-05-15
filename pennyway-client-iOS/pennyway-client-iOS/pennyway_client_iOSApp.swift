import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SwiftUI

// MARK: - pennyway_client_iOSApp

@main
struct pennyway_client_iOSApp: App {
    @StateObject private var appViewModel = AppViewModel()

    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as! String
        KakaoSDK.initSDK(appKey: kakaoAppKey, loggingEnable: false)
    }

    var body: some Scene {
        WindowGroup {
            Group {
                NavigationAvailable {
                    if appViewModel.isLoggedIn {
                        MainTabView()

                    } else {
                        if appViewModel.isSplashShown {
                            LoginView()

                        } else {
                            MainView()
                        }
                    }
                }
            }
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .environmentObject(appViewModel)
        }
    }
}
