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
        KeychainHelper.saveAccessToken(accessToken: "eyJyZWdEYXRlIjoxNzE2ODIxNzE0MDA4LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjYyIiwicm9sZSI6IlJPTEVfVVNFUiIsImV4cCI6MTcxNjgyMzUxNH0.B4HDsDxsXwdWRyPijSj85oBhSWTc1xfMFWfxe8QHe7I")
    }

    var body: some Scene {
        WindowGroup {
            if appViewModel.isLoggedIn || appViewModel.checkLoginState {
                MainTabView()
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .environmentObject(appViewModel)

            } else {
                if appViewModel.isSplashShown {
                    LoginView()
                        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                        .onOpenURL { url in
                            GIDSignIn.sharedInstance.handle(url)
                        }
                        .environmentObject(appViewModel)

                } else {
                    MainView()
                        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                        .onOpenURL { url in
                            GIDSignIn.sharedInstance.handle(url)
                        }
                        .environmentObject(appViewModel)
                }
            }
        }
    }
}
