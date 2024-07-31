///
///  AnalyticsConstants.swift
///  pennyway-client-iOS
///
///  Created by 양재서 on 7/30/24.
///
enum AnalyticsConstants {
    enum EventName {
        case screenView
        
        var rawValue: String {
            switch self {
            case .screenView: return "screen_view"
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
        
        var rawValue: String {
            switch self {
            case .screenId: return "screen_id"
            case .screenName: return "screen_name"
            case .screenClass: return "screen_class"
            }
        }
    }
}
