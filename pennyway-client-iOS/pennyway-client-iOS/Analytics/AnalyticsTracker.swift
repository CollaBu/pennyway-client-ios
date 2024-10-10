//
//  AnalyticsTracker.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import SwiftUI

// MARK: - AnalyticsEventTracker

struct AnalyticsEventTracker: ViewModifier {
    let event: AnalyticsEvent
    let additionalParams: [AnalyticsConstants.Parameter: Any]?

    func body(content: Content) -> some View {
        content.onAppear {
            AnalyticsManager.shared.trackEvent(event, additionalParams: additionalParams)
        }
    }
}

// MARK: - AnalyticeUserTracker

struct AnalyticeUserTracker: ViewModifier {
    let userId: String
    let properties: [String: String]?

    func body(content: Content) -> some View {
        content.onAppear {
            AnalyticsManager.shared.setUser(userId, properties)
        }
    }
}

extension View {
    func analyzeEvent(_ event: AnalyticsEvent, additionalParams: [AnalyticsConstants.Parameter: Any]? = nil) -> some View {
        modifier(AnalyticsEventTracker(event: event, additionalParams: additionalParams))
    }

    func analyzeUser(_ userId: String, properties: [String: String]? = [:]) -> some View {
        modifier(AnalyticeUserTracker(userId: userId, properties: properties))
    }
}
