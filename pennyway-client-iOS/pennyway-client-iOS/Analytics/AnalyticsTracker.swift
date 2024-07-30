//
//  AnalyticsScreenTracker.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import SwiftUI

struct AnalyticsEventTracker: ViewModifier {
    let event: AnalyticsEvent
    let additionalParams: [AnalyticsConstants.Parameter: Any]?
    
    func body(content: Content) -> some View {
        content.onAppear {
            AnalyticsManager.shared.trackEvent(event, additionalParams: additionalParams)
        }
    }
}

struct AnalyticeUserTracker: ViewModifier {
    let userId: String
    let properties: [String: Any]?
    
    func body(content: Content) -> some View {
        content.onAppear {
            AnalyticsManager.shared.setUser(userId, properties)
        }
    }
}

extension View {
    func analyzeEvent(_ event: AnalyticsEvent, additionalParams: [AnalyticsConstants.Parameter: Any]? = nil) -> some View {
        self.modifier(AnalyticsEventTracker(event: event, additionalParams: additionalParams))
    }
    
    func analyzeUser(_ userId: String, properties: [String: Any]? = nil) -> some View {
        self.modifier(AnalyticeUserTracker(userId: userId, properties: properties))
    }
}
