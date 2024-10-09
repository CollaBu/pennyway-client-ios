//
//  AuthCheckAnalyticsEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/8/24.
//

// MARK: - AuthCheckEvents

enum AuthCheckEvents: AnalyticsEvent {
    // 아이디 찾기 이벤트
    case findUsernameView
    case findUsernamePhoneVerificationView
    
    // 비밀번호 찾기 이벤트
    case findPasswordView
    case findPasswordPhoneVerificationView
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .findUsernameView, .findUsernamePhoneVerificationView,
             .findPasswordView, .findPasswordPhoneVerificationView:
            return AnalyticsConstants.EventName.screenView
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .findUsernameView, .findUsernamePhoneVerificationView,
             .findPasswordView, .findPasswordPhoneVerificationView:
            return AnalyticsConstants.EventType.screenView
        }
    }
        
    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .findUsernameView:
            return [
                .screenId: AuthCheckScreen.findUsernameView.screenId,
                .screenName: AuthCheckScreen.findUsernameView.screenName,
                .screenClass: AuthCheckScreen.findUsernameView.screenClass
            ]
        case .findUsernamePhoneVerificationView:
            return [
                .screenId: AuthCheckScreen.findUsernamePhoneVerificationView.screenId,
                .screenName: AuthCheckScreen.findUsernamePhoneVerificationView.screenName,
                .screenClass: AuthCheckScreen.findUsernamePhoneVerificationView.screenClass
            ]
        case .findPasswordView:
            return [
                .screenId: AuthCheckScreen.findPasswordView.screenId,
                .screenName: AuthCheckScreen.findPasswordView.screenName,
                .screenClass: AuthCheckScreen.findPasswordView.screenClass
            ]
        case .findPasswordPhoneVerificationView:
            return [
                .screenId: AuthCheckScreen.findPasswordPhoneVerification.screenId,
                .screenName: AuthCheckScreen.findPasswordPhoneVerification.screenName,
                .screenClass: AuthCheckScreen.findPasswordPhoneVerification.screenClass
            ]
        }
    }
}

// MARK: - AuthCheckScreen

enum AuthCheckScreen {
    // 아이디 찾기 이벤트
    case findUsernameView
    case findUsernamePhoneVerificationView
    
    // 비밀번호 찾기 이벤트
    case findPasswordView
    case findPasswordPhoneVerification
    
    var screenId: String {
        switch self {
        case .findUsernameView: return "find_username_screen_view_event"
        case .findUsernamePhoneVerificationView: return "find_username_phone_verification_screen_view_event"
        case .findPasswordView: return "find_password_screen_view_event"
        case .findPasswordPhoneVerification: return "find_password_phone_verification_screen_view_event"
        }
    }
    
    var screenName: String {
        switch self {
        case .findUsernameView: return "아이디 찾기 화면"
        case .findUsernamePhoneVerificationView: return "아이디 찾기 휴대폰 인증 화면"
        case .findPasswordView: return "비밀번호 찾기 화면"
        case .findPasswordPhoneVerification: return "비밀번호 찾기 휴대폰 인증 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .findUsernameView: return "FindIdView"
        case .findUsernamePhoneVerificationView: return "FindIdContentView"
        case .findPasswordView: return "ResetPwView"
        case .findPasswordPhoneVerification: return "FindPwView"
        }
    }
}
