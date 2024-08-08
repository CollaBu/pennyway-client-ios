// MARK: - AuthEvents

///
///  AuthenticationEvents.swift
///  pennyway-client-iOS
///
///  Created by 양재서 on 7/30/24.
///
enum AuthEvents: AnalyticsEvent {
    // 로그인 이벤트
    case loginView
    case oauthSignInBtnTapped
    
    // 공용
    case phoneVerificationView
    case tosView
    case welcomeView
    
    // 일반 회원가입 이벤트
    case generalSignUpView
    case existsOauthAccountView
    case generalSignSycnView
    
    case idCancelBtnTapped
    case pwCancelBtnTapped
    
    /// 소셜 회원가입 이벤트
    case oauthSignUpView
    
    // 아이디 찾기 이벤트
    case findUsernameView
    case findUsernamePhoneVerificationView
    
    // 비밀번호 찾기 이벤트
    case findPasswordView
    case findPasswordPhoneVerificationView
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .loginView, .phoneVerificationView, .tosView, .welcomeView, .generalSignUpView, .existsOauthAccountView,
             .generalSignSycnView, .oauthSignUpView, .findUsernameView,
             .findUsernamePhoneVerificationView, .findPasswordView, .findPasswordPhoneVerificationView:
            return AnalyticsConstants.EventName.screenView
        case .oauthSignInBtnTapped, .idCancelBtnTapped, .pwCancelBtnTapped:
            return AnalyticsConstants.EventName.btnTapped
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .loginView, .phoneVerificationView, .tosView, .welcomeView, .generalSignUpView, .existsOauthAccountView,
             .generalSignSycnView, .oauthSignUpView, .findUsernameView,
             .findUsernamePhoneVerificationView, .findPasswordView, .findPasswordPhoneVerificationView:
            return AnalyticsConstants.EventType.screenView
        case .oauthSignInBtnTapped, .idCancelBtnTapped, .pwCancelBtnTapped:
            return AnalyticsConstants.EventType.userAction
        }
    }
    
    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .loginView:
            return [
                .screenId: AuthScreen.loginView.screenId,
                .screenName: AuthScreen.loginView.screenName,
                .screenClass: AuthScreen.loginView.screenClass
            ]
        case .oauthSignInBtnTapped:
            return [
                .eventName: AuthEvent.oauthSignInBtnTapped.eventName,
            ]
        case .phoneVerificationView:
            return [
                .screenId: AuthScreen.phoneVerificationView.screenId,
                .screenName: AuthScreen.phoneVerificationView.screenName,
                .screenClass: AuthScreen.phoneVerificationView.screenClass
            ]
        case .tosView:
            return [
                .screenId: AuthScreen.tosView.screenId,
                .screenName: AuthScreen.tosView.screenName,
                .screenClass: AuthScreen.tosView.screenClass
            ]
        case .welcomeView:
            return [
                .screenId: AuthScreen.welcomeView.screenId,
                .screenName: AuthScreen.welcomeView.screenName,
                .screenClass: AuthScreen.welcomeView.screenClass
            ]
        case .generalSignUpView:
            return [
                .screenId: AuthScreen.generalSignUpView.screenId,
                .screenName: AuthScreen.generalSignUpView.screenName,
                .screenClass: AuthScreen.generalSignUpView.screenClass
            ]
        case .existsOauthAccountView:
            return [
                .screenId: AuthScreen.existsOauthAccountView.screenId,
                .screenName: AuthScreen.existsOauthAccountView.screenName,
                .screenClass: AuthScreen.existsOauthAccountView.screenClass
            ]
        case .generalSignSycnView:
            return [
                .screenId: AuthScreen.generalSignSycnView.screenId,
                .screenName: AuthScreen.generalSignSycnView.screenName,
                .screenClass: AuthScreen.generalSignSycnView.screenClass
            ]
        case .idCancelBtnTapped:
            return [
                .eventName: AuthEvent.idCancelBtnTapped.eventName
            ]
        case .pwCancelBtnTapped:
            return [
                .eventName: AuthEvent.pwCancelBtnTapped.eventName
            ]
        case .oauthSignUpView:
            return [
                .screenId: AuthScreen.oauthSignUpView.screenId,
                .screenName: AuthScreen.oauthSignUpView.screenName,
                .screenClass: AuthScreen.oauthSignUpView.screenClass
            ]
        case .findUsernameView:
            return [
                .screenId: AuthScreen.findUsernameView.screenId,
                .screenName: AuthScreen.findUsernameView.screenName,
                .screenClass: AuthScreen.findUsernameView.screenClass
            ]
        case .findUsernamePhoneVerificationView:
            return [
                .screenId: AuthScreen.findUsernamePhoneVerificationView.screenId,
                .screenName: AuthScreen.findUsernamePhoneVerificationView.screenName,
                .screenClass: AuthScreen.findUsernamePhoneVerificationView.screenClass
            ]
        case .findPasswordView:
            return [
                .screenId: AuthScreen.findPasswordView.screenId,
                .screenName: AuthScreen.findPasswordView.screenName,
                .screenClass: AuthScreen.findPasswordView.screenClass
            ]
        case .findPasswordPhoneVerificationView:
            return [
                .screenId: AuthScreen.findPasswordPhoneVerification.screenId,
                .screenName: AuthScreen.findPasswordPhoneVerification.screenName,
                .screenClass: AuthScreen.findPasswordPhoneVerification.screenClass
            ]
        }
    }
}

// MARK: - AuthScreen

enum AuthScreen {
    /// 로그인
    case loginView
    
    // 공용
    case phoneVerificationView
    case tosView
    case welcomeView
    
    // 일반 회원가입 이벤트
    case generalSignUpView
    case existsOauthAccountView
    case generalSignSycnView
    
    /// 소셜 회원가입 이벤트
    case oauthSignUpView
    
    // 아이디 찾기 이벤트
    case findUsernameView
    case findUsernamePhoneVerificationView
    
    // 비밀번호 찾기 이벤트
    case findPasswordView
    case findPasswordPhoneVerification
    
    var screenId: String {
        switch self {
        case .loginView: return "login_screen_view_event"
        case .phoneVerificationView: return "phone_verification_screen_view_event"
        case .tosView: return "tos_screen_view_event"
        case .welcomeView: return "welcome_screen_view_event"
        case .generalSignUpView: return "general_signup_screen_view_event"
        case .existsOauthAccountView: return "exists_oauth_account_screen_view_event"
        case .generalSignSycnView: return "general_signup_sync_screen_view_event"
        case .oauthSignUpView: return "oauth_signup_screen_view_event"
        case .findUsernameView: return "find_username_screen_view_event"
        case .findUsernamePhoneVerificationView: return "find_username_phone_verification_screen_view_event"
        case .findPasswordView: return "find_password_screen_view_event"
        case .findPasswordPhoneVerification: return "find_password_phone_verification_screen_view_event"
        }
    }
    
    var screenName: String {
        switch self {
        case .loginView: return "로그인 화면"
        case .phoneVerificationView: return "휴대폰 인증 화면"
        case .tosView: return "이용약관 화면"
        case .welcomeView: return "회원가입 성공 화면"
        case .generalSignUpView: return "일반 회원가입 화면"
        case .existsOauthAccountView: return "일반 회원가입 - 소셜 계정 존재 확인 화면"
        case .generalSignSycnView: return "일반 회원가입 - 소셜 계정 연동 화면"
        case .oauthSignUpView: return "소셜 회원가입 화면"
        case .findUsernameView: return "아이디 찾기 화면"
        case .findUsernamePhoneVerificationView: return "아이디 찾기 휴대폰 인증 화면"
        case .findPasswordView: return "비밀번호 찾기 화면"
        case .findPasswordPhoneVerification: return "비밀번호 찾기 휴대폰 인증 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .loginView: return "LoginView"
        case .phoneVerificationView: return "PhoneVerificationView"
        case .tosView: return "TermsAndConditionsView"
        case .welcomeView: return "WelcomeView"
        case .generalSignUpView: return "SignUpView"
        case .existsOauthAccountView: return "OAuthAccountLinkingView"
        case .generalSignSycnView: return "OAuthAccountLinkingView"
        case .oauthSignUpView: return "SignUpView"
        case .findUsernameView: return "FindIdView"
        case .findUsernamePhoneVerificationView: return "FindIdPhoneVerificationView"
        case .findPasswordView: return "FindPwView"
        case .findPasswordPhoneVerification: return "FindPwPhoneVerification"
        }
    }
}

// MARK: - AuthEvent

enum AuthEvent {
    case oauthSignInBtnTapped
    
    case idCancelBtnTapped
    case pwCancelBtnTapped
    
    var eventName: String {
        switch self {
        case .oauthSignInBtnTapped: return "oauth_sign_in_btn_tapped"
            
        case .idCancelBtnTapped: return "id_cancel_btn_tapped"
        case .pwCancelBtnTapped: return "pw_cancel_btn_tapped"
        }
    }
}
