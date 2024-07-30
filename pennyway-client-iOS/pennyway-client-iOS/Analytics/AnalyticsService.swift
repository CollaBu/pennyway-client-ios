//
//  AnalyticsService.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import Foundation
import UIKit

protocol AnalyticsService {
    /**
     SDK를 초기화한다.
     > 이 메서드는 AppDelegate application:didFinishLaunchingWithOptions: 메서드 내에서 반드시 호출되어야 한다.
     */
    func initialize(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    
    /**
     앱 내에서 구독할 이벤트를 등록한다.
     */
    func subscribe(event: AnalyticsEvent)
    
    /**
     사용자 정보를 설정한다.
     
      - Parameters:
        - userId: 사용자 식별자 정보 (고유값)
        - properties: 사용자 추가 정보 (옵션)
     */
    func setUser(_ userId: String, _ properties: [String: Any]?)
    
    /**
     구독할 화면 이벤트의 목록을 제공하는 변수.
     
     - Note: 이 변수는 구독할 화면 이벤트의 배열을 반환합니다. 구독할 화면 이벤트를 설정하려면 이 변수를 구현하는 클래스 또는 구조체에서 배열을 반환하도록 해야 합니다.
     */
    var subscribeScreens: [ScreenViewEvent] { get }
    
    /**
     구독할 트리거 이벤트의 목록을 제공하는 변수.
         
     - Note: 이 변수는 구독할 트리거 이벤트의 배열을 반환합니다. 구독할 트리거 이벤트를 설정하려면 이 변수를 구현하는 클래스 또는 구조체에서 배열을 반환하도록 해야 합니다.
    */
    var subscribeTriggerEvents: [TriggerEvent] { get }
}

// MARK: Default Behavior
extension AnalyticsService {
    var subscribeScreenEvents: [ScreenViewEvent] {
        return AnalyticsEvent.allScreenEvent
    }
    
    var subscribeTriggerEvents: [TriggerEvent] {
        return AnalyticsEvent.allTriggerEvent
    }
}

// MARK: Convenience Methods
extension AnalyticsService {
    /**
     화면 이벤트가 구독된 이벤트 목록에 포함되어 있는지 확인한다.
     
     - Parameter event: 확인하려는 `ScreenViewEvent`
     - Returns: 이벤트가 구독된 목록에 포함되어 있으면 `true`, 그렇지 않으면 `false`
     */
    func shouldSubscribeScreenEvent(event: ScreenViewEvent) -> Bool {
        return subscribeScreenEvents.contains{ $0.name == event.name }
    }
    
    /**
     트리거 이벤트가 구독된 이벤트 목록에 포함되어 있는지 확인한다.
     
     - Parameter event: 확인하려는 `TriggerEvent`
     - Returns: 이벤트가 구독된 목록에 포함되어 있으면 `true`, 그렇지 않으면 `false`
     */
    func shouldSubscribeTriggerEvent(event: TriggerEvent) -> Bool {
        return subscribeTriggerEvents.contains{ $0.name == event.name }
    }
}
