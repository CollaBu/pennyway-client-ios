//
//  AppDelegate.swift
//  pennyway-client-iOS
//

import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as! String
        KakaoSDK.initSDK(appKey: kakaoAppKey, loggingEnable: false)

        return true
    }
}
