//
//  AuthenticationEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//
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
                .screenId: AuthScreen.login.screenId,
                .screenName: AuthScreen.login.screenName,
                .screenClass: AuthScreen.login.screenClass
            ]
        }
    }
}

enum AuthScreen {
    case login
    
    var screenId: String {
        switch self {
        case .login: return "login_screen_view_event"
        }
    }
    
    var screenName: String {
        switch self {
        case .login: return "로그인 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .login: return "LoginView"
        }
    }
}
