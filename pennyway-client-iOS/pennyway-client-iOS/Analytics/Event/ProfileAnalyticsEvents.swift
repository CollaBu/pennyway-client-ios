//
//  ProfileAnalyticsEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/21/24.
//

enum ProfileEvents: AnalyticsEvent {
    case profileTapView
    case profileHamburgerMenuTap
    
    case profileEditView
    case nameEditView
    case usernameEditView
    case phoneEditView
    case currentPasswordCheckView
    case passwordEditView
    case passwordEditCompleteView
    case profileImageEditPopUp
    
    case notificationEditView
    
    case accountDeletePopUp
    case accountDeleteSuccessPopUp
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .profileTapView, .profileHamburgerMenuTap, .profileEditView, .nameEditView, .usernameEditView, .phoneEditView, .currentPasswordCheckView, .passwordEditView, .passwordEditCompleteView, .profileImageEditPopUp, .notificationEditView, .accountDeletePopUp, .accountDeleteSuccessPopUp:
            return AnalyticsConstants.EventName.screenView
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .profileTapView, .profileHamburgerMenuTap, .profileEditView, .nameEditView, .usernameEditView, .phoneEditView, .currentPasswordCheckView, .passwordEditView, .passwordEditCompleteView, .profileImageEditPopUp, .notificationEditView, .accountDeletePopUp, .accountDeleteSuccessPopUp:
            return AnalyticsConstants.EventType.screenView
        }
    }
    
    var parameters: [AnalyticsConstants.Parameter : Any]? {
        switch self {
        case .profileTapView: [
            .screenId: ProfileScreen.profileTapView.screenId,
            .screenName: ProfileScreen.profileTapView.screenName,
            .screenClass: ProfileScreen.profileTapView.screenClass
        ]
        case .profileHamburgerMenuTap: [
            .screenId: ProfileScreen.profileHamburgerMenuTap.screenId,
            .screenName: ProfileScreen.profileHamburgerMenuTap.screenName,
            .screenClass: ProfileScreen.profileHamburgerMenuTap.screenClass
        ]
        case .profileEditView: [
            .screenId: ProfileScreen.profileEditView.screenId,
            .screenName: ProfileScreen.profileEditView.screenName,
            .screenClass: ProfileScreen.profileEditView.screenClass
        ]
        case .nameEditView: [
            .screenId: ProfileScreen.nameEditView.screenId,
            .screenName: ProfileScreen.nameEditView.screenName,
            .screenClass: ProfileScreen.nameEditView.screenClass
        ]
        case .usernameEditView: [
            .screenId: ProfileScreen.usernameEditView.screenId,
            .screenName: ProfileScreen.usernameEditView.screenName,
            .screenClass: ProfileScreen.usernameEditView.screenClass
        ]
        case .phoneEditView: [
            .screenId: ProfileScreen.phoneEditView.screenId,
            .screenName: ProfileScreen.phoneEditView.screenName,
            .screenClass: ProfileScreen.phoneEditView.screenClass
        ]
        case .currentPasswordCheckView: [
            .screenId: ProfileScreen.currentPasswordCheckView.screenId,
            .screenName: ProfileScreen.currentPasswordCheckView.screenName,
            .screenClass: ProfileScreen.currentPasswordCheckView.screenClass
        ]
        case .passwordEditView: [
            .screenId: ProfileScreen.passwordEditView.screenId,
            .screenName: ProfileScreen.passwordEditView.screenName,
            .screenClass: ProfileScreen.passwordEditView.screenClass
        ]
        case .passwordEditCompleteView: [
            .screenId: ProfileScreen.passwordEditCompleteView.screenId,
            .screenName: ProfileScreen.passwordEditCompleteView.screenName,
            .screenClass: ProfileScreen.passwordEditCompleteView.screenClass
        ]
        case .profileImageEditPopUp: [
            .screenId: ProfileScreen.profileImageEditPopUp.screenId,
            .screenName: ProfileScreen.profileImageEditPopUp.screenName,
            .screenClass: ProfileScreen.profileImageEditPopUp.screenClass
        ]
        case .notificationEditView: [
            .screenId: ProfileScreen.notificationEditView.screenId,
            .screenName: ProfileScreen.notificationEditView.screenName,
            .screenClass: ProfileScreen.notificationEditView.screenClass
        ]
        case .accountDeletePopUp: [
            .screenId: ProfileScreen.accountDeletePopUp.screenId,
            .screenName: ProfileScreen.accountDeletePopUp.screenName,
            .screenClass: ProfileScreen.accountDeletePopUp.screenClass
        ]
        case .accountDeleteSuccessPopUp: [
            .screenId: ProfileScreen.accountDeleteSuccessPopUp.screenId,
            .screenName: ProfileScreen.accountDeleteSuccessPopUp.screenName,
            .screenClass: ProfileScreen.accountDeleteSuccessPopUp.screenClass
        ]
        }
    }
}

enum ProfileScreen {
    case profileTapView
    case profileHamburgerMenuTap
    
    case profileEditView
    case nameEditView
    case usernameEditView
    case phoneEditView
    case currentPasswordCheckView
    case passwordEditView
    case passwordEditCompleteView
    case profileImageEditPopUp
    
    case notificationEditView
    
    case accountDeletePopUp
    case accountDeleteSuccessPopUp
    
    var screenId: String {
        switch self {
            case .profileTapView: return "profile_tap_view"
            case .profileHamburgerMenuTap: return "profile_hamburger_menu_tap"
            case .profileEditView: return "profile_edit_view"
            case .nameEditView: return "name_edit_view"
            case .usernameEditView: return "username_edit_view"
            case .phoneEditView: return "phone_edit_view"
            case .currentPasswordCheckView: return "current_password_check_view"
            case .passwordEditView: return "password_edit_view"
            case .passwordEditCompleteView: return "password_edit_complete_view"
            case .profileImageEditPopUp: return "profile_image_edit_popup"
            case .notificationEditView: return "notification_edit_view"
            case .accountDeletePopUp: return "account_delete_popup"
            case .accountDeleteSuccessPopUp: return "account_delete_success_popup"
        }
    }
 
    var screenName: String {
        switch self {
            case .profileTapView: return "프로필 탭 바 화면"
            case .profileHamburgerMenuTap: return "프로필 햄버거 메뉴 화면"
            case .profileEditView: return "내 정보 수정 화면"
            case .nameEditView: return "이름 수정 화면"
            case .usernameEditView: return "아이디 수정 화면"
            case .phoneEditView: return "전화번호 수정 화면"
            case .currentPasswordCheckView: return "현재 비밀번호 확인 화면"
            case .passwordEditView: return "비밀번호 수정 화면"
            case .passwordEditCompleteView: return "비밀번호 수정 완료 화면"
            case .profileImageEditPopUp: return "프로필 이미지 수정 팝업"
            case .notificationEditView: return "알림 설정 화면"
            case .accountDeletePopUp: return "계정 삭제 팝업"
            case .accountDeleteSuccessPopUp: return "계정 삭제 성공 팝업"
        }
    }
    
    var screenClass: String {
        switch self {
            case .profileTapView: return "ProfileMainView"
            case .profileHamburgerMenuTap: return "ProfileMenuBarListView"
            case .profileEditView: return "EditProfileListView"
            case .nameEditView: return "EditUsernameView"
            case .usernameEditView: return "EditIdView"
            case .phoneEditView: return "EditPhoneNumberView"
            case .currentPasswordCheckView: return "ProfileModifyPwView"
            case .passwordEditView: return "ResetPwView"
            case .passwordEditCompleteView: return "CompleteChangePwView"
            case .profileImageEditPopUp: return "EditProfilePopView"
            case .notificationEditView: return "SettingAlarmView"
            case .accountDeletePopUp: return "ProfileMenuBarListView"
            case .accountDeleteSuccessPopUp: return "CompleteDeleteUserView"
        }
    }
}
