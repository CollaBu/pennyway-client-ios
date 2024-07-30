//
//  SpendingEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import Foundation

enum SpendingEvents: AnalyticsEvent {
    // MARK: - Spending List Screen View Event
    case spendingListView
    case detailSpendingView
    case addSpendingInputFormView
    case mySpendingListScreenView
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .spendingListView, .detailSpendingView, .addSpendingInputFormView, .mySpendingListScreenView:
            return AnalyticsConstants.EventName.screenView
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .spendingListView, .detailSpendingView, .addSpendingInputFormView, .mySpendingListScreenView:
            return AnalyticsConstants.EventType.screenView
        }
    }
    
    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .spendingListView:
            return [
                .screenId: "spending_list_screen_view_event",
                .screenName: "지출 리스트 화면",
                .screenClass: "SpendingListView"
            ]
        case .detailSpendingView:
            return [
                .screenId: "spending_detail_screen_view_event",
                .screenName: "지출 상세 화면",
                .screenClass: "DetailSpendingView"
            ]
        case .addSpendingInputFormView:
            return [
                .screenId: "spending_add_screen_view_event",
                .screenName: "지출 추가 화면",
                .screenClass: "AddSpendingInputFormView"
            ]
        case .mySpendingListScreenView:
            return [
                .screenId: "my_spending_list_screen_view_event",
                .screenName: "나의 지출 리스트 화면",
                .screenClass: "MySpendingListView"
            ]
        }
    }
}
