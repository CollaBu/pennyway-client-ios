///
///  AnalyticsConstants.swift
///  pennyway-client-iOS
///
///  Created by 양재서 on 7/30/24.
///
enum AnalyticsConstants {
    enum EventName {
        case screenView
        case login
        case signUp

        case btnTapped

        var rawValue: String {
            switch self {
            case .screenView: return "screen_view"
            case .login: return "login"
            case .signUp: return "sign_up"
            case .btnTapped: return "btn_tapped"
            }
        }
    }

    enum EventType {
        case screenView
        case userAction

        var rawValue: String {
            switch self {
            case .screenView: return "screen_view"
            case .userAction: return "user_action"
            }
        }
    }

    enum Parameter {
        case screenId
        case screenName
        case screenClass

        case eventName

        case isRefresh
        case oauthType
        case btnName
        case date

        var rawValue: String {
            switch self {
            case .screenId: return "screen_id"
            case .screenName: return "screen_name"
            case .screenClass: return "screen_class"
            case .eventName: return "event_name"
            case .isRefresh: return "is_refresh"
            case .oauthType: return "method"
            case .btnName: return "btn_name"
            case .date: return "date"
            }
        }
    }
}
