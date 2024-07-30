//
//  AnalyticsEvent.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import Foundation

enum AnalyticsEvent {
    case screenView(ScreenViewEvent)
    case eventLog(EventLog)
    
    var name: String {
        switch self {
        case .screenView(let event):
            return event.name
        case .eventLog(let event):
            return event.name
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .screenView(let event):
            return event.parameters
        case .eventLog(let event):
            return event.parameters
        }
    }
}

/**
 *  화면 정보를 정의한다.
 *
 *  - Parameters: name (analytics 대시보드에 표시될 화면 이름), className (analytics 대시보드에 표시될 클래스명), parameters (추가적인 정보, 선택 사항)
 */
struct ScreenViewEvent {
    let name: String
    let className: String
    
    var parameters: [String: Any] {
        return ["screenName": name, "screenClass": className]
    }
}

/**
 *  이벤트 정보를 정의한다.
 *
 *  - Parameters: name (analytics 대시보드에 표시될 이벤트 이름), parameters (추가적인 정보, 선택 사항)
 */
struct EventLog {
    let name: String
    let parameters: [String: Any]?
}

extension AnalyticsEvent {
    /**
     *  서비스 내 화면 정보를 상수로써 정의한다.
     */
    enum Screen {
        static let loginView = ScreenViewEvent(name: "로그인 화면", className: "LoginView")
    }
    
    /**
     *  서비스 내 이벤트 정보를 상수로써 정의한다.
     */
    enum Trigger {
        static let login = EventLog(name: "user_login", parameters: nil)
        
        static let buttonTap = EventLog(name: "button_tapped", parameters: nil)
    }
    
    /**
     *  이 속성은 오직 편의용 메서드로 사용한다.
     *  만약, analytics serivce에서 모든 이벤트를 구독할 때, 이 메서드를 사용하면 정의된 모든 이벤트를 반환한다.
     */
    static var all: [AnalyticsEvent] = {
        var events = [AnalyticsEvent]()
        
        AnalyticsEvent.all.forEach { AnalyticsEvent in
            events.append(AnalyticsEvent)
        }
        
        return events
    }()
}
