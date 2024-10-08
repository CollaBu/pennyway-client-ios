//
//  AnalyticsEvent.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

/// 분석 이벤트 로그에 대한 프로토콜
///
/// - Parameters:
///    - eventName: 이벤트 이름. 분석 도구에서 사용하는 이벤트 이름을 나타낸다.
///    - eventType: 이벤트 타입. 분석 도구에서 사용하는 이벤트 유형을 나타낸다. GA4의 경우 자동 수집 이벤트, 향상된 측정 이벤트, 맞춤 이벤트, 추천 이벤트가 있다. 이는 provider에 따라 다를 수 있다.
///    - parameters: 이벤트 파라미터. eventType과 eventName에 대한 추가 정보를 제공한다.
///
protocol AnalyticsEvent {
    var eventName: AnalyticsConstants.EventName { get }
    var eventType: AnalyticsConstants.EventType { get }
    var parameters: [AnalyticsConstants.Parameter: Any]? { get }
}
