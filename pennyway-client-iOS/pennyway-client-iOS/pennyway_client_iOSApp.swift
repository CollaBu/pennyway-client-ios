import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SwiftUI

@main
struct pennyway_client_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
