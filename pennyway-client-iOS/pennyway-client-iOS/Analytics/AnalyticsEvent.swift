//
//  AnalyticsEvent.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

/// 분석 이벤트 로그에 대한 프로토콜
///
/// - Parameters:
///    - eventName: 이벤트 이름. `AnalyticsConstants.EventName`을 타입으로 갖는다.
///    - eventType: 이벤트 타입. `AnalyticsConstants.EventType`을 타입으로 갖는다.
///    - parameters: 이벤트 파라미터. `AnalyticsConstants.Parameter`를 키로, 파라미터 값은 `Any`로 갖는다.
/// 
protocol AnalyticsEvent {
    var eventName: AnalyticsConstants.EventName { get }
    var eventType: AnalyticsConstants.EventType { get }
    var parameters: [AnalyticsConstants.Parameter: Any]? { get }
}
