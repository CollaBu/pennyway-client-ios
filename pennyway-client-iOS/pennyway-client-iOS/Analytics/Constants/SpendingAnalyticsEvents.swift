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
                .screenId: SpendingScreen.spendingListView.screenId,
                .screenName: SpendingScreen.spendingListView.screenName,
                .screenClass: SpendingScreen.spendingListView.screenClass
            ]
        case .detailSpendingView:
            return [
                .screenId: SpendingScreen.detailSpendingView.screenId,
                .screenName: SpendingScreen.detailSpendingView.screenName,
                .screenClass: SpendingScreen.detailSpendingView.screenClass
            ]
        case .addSpendingInputFormView:
            return [
                .screenId: SpendingScreen.addSpendingInputFormView.screenId,
                .screenName: SpendingScreen.addSpendingInputFormView.screenName,
                .screenClass: SpendingScreen.addSpendingInputFormView.screenClass
            ]
        case .mySpendingListScreenView:
            return [
                .screenId: SpendingScreen.mySpendingListScreenView.screenId,
                .screenName: SpendingScreen.mySpendingListScreenView.screenName,
                .screenClass: SpendingScreen.mySpendingListScreenView.screenClass
            ]
        }
    }
}

enum SpendingScreen {
    case spendingListView
    case detailSpendingView
    case addSpendingInputFormView
    case mySpendingListScreenView
    
    var screenId: String {
        switch self {
        case .spendingListView: return "spending_list_screen_view_event"
        case .detailSpendingView: return "spending_detail_screen_view_event"
        case .addSpendingInputFormView: return "spending_add_screen_view_event"
        case .mySpendingListScreenView: return "my_spending_list_screen_view_event"
        }
    }
    
    var screenName: String {
        switch self {
        case .spendingListView: return "지출 리스트 화면"
        case .detailSpendingView: return "지출 상세 화면"
        case .addSpendingInputFormView: return "지출 추가 화면"
        case .mySpendingListScreenView: return "나의 지출 리스트 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .spendingListView: return "SpendingListView"
        case .detailSpendingView: return "DetailSpendingView"
        case .addSpendingInputFormView: return "AddSpendingInputFormView"
        case .mySpendingListScreenView: return "MySpendingListView"
        }
    }
}
