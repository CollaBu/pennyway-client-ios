//
//  FirebaseAnalyticsService.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import FirebaseAnalytics
import SwiftUI

class FirebaseAnalyticsService: AnalyticsService {
    var subscribedEvents: [AnalyticsEvent.Type] {
        [AuthEvents.self, AuthCheckEvents.self, SpendingEvents.self, SpendingCategoryEvents.self, TargetAmountEvents.self, ProfileEvents.self, QuestionEvents.self]
    }

    func initialize(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        Log.info("[FirebaseAnalyticsService]: Initialized")
    }

    func track(_ event: any AnalyticsEvent, additionalParams: [AnalyticsConstants.Parameter: Any]?) {
        let eventName = getFirebaseEventName(for: event.eventName)
        let firebaseParams = convertParameters(event, additionalParams)

        Analytics.logEvent(eventName, parameters: firebaseParams)

        Log.info("[FirebaseAnalyticsService]: Tracking event \(event) with parameters \(String(describing: additionalParams))")
    }

    /// - Parameters:
    ///  - userId:
    ///   The user ID to ascribe to the user of this app on this device, which must be non-empty and no more than 256 characters long. Setting userID to nil removes the user ID.
    ///  - value:
    ///   The value of the user property. Values can be up to 36 characters long. Setting the value to nil removes the user property.
    ///  - name:
    ///   The name of the user property to set. Should contain 1 to 24 alphanumeric characters or underscores and must start with an alphabetic character. The “firebase_”, “google_”, and “ga_” prefixes are reserved and should not be used for user property names.
    func setUser(_ userId: String, _ properties: [String: String]?) {
        Analytics.setUserID(userId)
        properties?.forEach { Analytics.setUserProperty($0.key, forName: $0.value) }

        Log.info("[FirebaseAnalyticsService]: Setting user \(userId) with properties \(String(describing: properties))")
    }

    private func getFirebaseEventName(for eventName: AnalyticsConstants.EventName) -> String {
        switch eventName {
        case .screenView:
            return AnalyticsEventScreenView
        case .login:
            return AnalyticsEventLogin
        case .signUp:
            return AnalyticsEventSignUp
        default:
            return eventName.rawValue
        }
    }

    /// 애플리케이션 내에서 사용하는 `AnalyticsEvent`를 Firebase Analytics에서 사용하는 이벤트로 변환한다.`
    private func convertParameters(_ event: AnalyticsEvent, _ additionalParams: [AnalyticsConstants.Parameter: Any]?) -> [String: Any] {
        var params: [String: Any] = [:]

        event.parameters?.forEach { key, value in
            params[getFirebaseParameterKey(for: key)] = value
        }

        additionalParams?.forEach { params[$0.key.rawValue] = $0.value }

        return params
    }

    private func getFirebaseParameterKey(for key: AnalyticsConstants.Parameter) -> String {
        switch key {
        case .screenId:
            return "firebase_screen_id"
        case .screenName:
            return AnalyticsParameterScreenName
        case .screenClass:
            return AnalyticsParameterScreenClass
        default:
            return key.rawValue
        }
    }
}
