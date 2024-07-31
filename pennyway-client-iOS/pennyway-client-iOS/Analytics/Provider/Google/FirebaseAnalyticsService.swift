//
//  FirebaseAnalyticsService.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import FirebaseAnalytics

class FirebaseAnalyticsService: AnalyticsService {
    var subscribedEvents: [AnalyticsEvent.Type] {
        [AuthenticationEvents.self, SpendingEvents.self]
    }
    
    func initialize(application _: UIApplication, launchOptions _: [UIApplication.LaunchOptionsKey: Any]?) {
        Log.info("Firebase: Initialized")
    }
    
    func track(_ event: any AnalyticsEvent, additionalParams: [AnalyticsConstants.Parameter: Any]?) {
        let firebaseParams = convertParameters(event, additionalParams)
        
        if event.eventName == .screenView {
            Analytics.logEvent(AnalyticsEventScreenView, parameters: firebaseParams)
        } else {
            Analytics.logEvent(event.eventName.rawValue, parameters: firebaseParams)
        }
        
        Log.info("Firebase: Tracking event \(event.eventName.rawValue) with parameters \(String(describing: additionalParams))")
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
        
        Log.info("Firebase: Setting user \(userId) with properties \(String(describing: properties))")
    }
    
    /// 애플리케이션 내에서 사용하는 `AnalyticsEvent`를 Firebase Analytics에서 사용하는 이벤트로 변환한다.`
    ///
    /// - todo: 이 메서드는 AnalyticsEvent의 종류가 많아질수록 수정이 필요하다.
    private func convertParameters(_ event: AnalyticsEvent, _ additionalParams: [AnalyticsConstants.Parameter: Any]?) -> [String: Any] {
        var params: [String: Any] = [:]
        
        // 이벤트 파라미터 변환
        event.parameters?.forEach { key, value in
            switch key {
            case .screenId:
                params["firebase_screen_id"] = value
            case .screenName:
                params[AnalyticsParameterScreenName] = value
            case .screenClass:
                params[AnalyticsParameterScreenClass] = value
            default:
                params[key.rawValue] = value // 그 외의 파라미터가 있다면 커스텀 파라미터로 취급
            }
        }
        
        additionalParams?.forEach { params[$0.key.rawValue] = $0.value }
        
        return params
    }
}
