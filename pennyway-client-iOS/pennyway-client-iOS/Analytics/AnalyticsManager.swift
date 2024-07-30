//
//  AnalyticsManager.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import Foundation
import UIKit

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private var services: [AnalyticsService] = []
    
    private init() {}
    
    /// AnalyticsService 프로토콜을 구현한 서비스를 추가한다.
    func addService(_ service: AnalyticsService) {
        services.append(service)
    }
    
    /// `addService` 메서드로 추가한 서비스들을 `AppDelegate`에서 초기화한다.
    /// 이 메서드는 반드시 AppDelegate의 `application(_:didFinishLaunchingWithOptions:)`에서 호출되어야 한다.
    func initialize(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        services.forEach { $0.initialize(application: application, launchOptions: launchOptions) }
    }
    
    /**
        구독된 이벤트를 추적한다.
     
        - Parameters:
            - event: 추적할 이벤트
            - additionalParams: 이벤트에 추가할 파라미터
     */
    func subscribe(_ event: AnalyticsEvent, additionalParams: [String: Any]?) {
        services.forEach { $0.trackEventIfSubscribed(event, additionalParams: additionalParams) }
    }
    
    /**
        사용자 정보를 설정한다.
     
        - Parameters:
            - userId: 사용자 식별자 정보 (고유값)
            - properties: 사용자 추가 정보 (옵션)
     */
    func setUser(_ userId: String, _ properties: [String: Any]? = nil) {
        services.forEach { $0.setUser(userId, properties) }
    }
}
