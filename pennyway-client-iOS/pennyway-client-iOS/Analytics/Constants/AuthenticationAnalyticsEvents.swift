//
//  AuthenticationEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import Foundation

enum AuthenticationEvents: AnalyticsEvent {
    case login
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .login: return AnalyticsConstants.EventName.screenView
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .login: return AnalyticsConstants.EventType.screenView
        }
    }
    
    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .login:
            return [
                .screenId: "login_screen_view_event",
                .screenName: "로그인 화면",
                .screenClass: "LoginView"
            ]
        }
    }
}
