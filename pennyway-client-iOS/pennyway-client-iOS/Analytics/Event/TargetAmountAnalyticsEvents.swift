//
//  TargetAmountAnalyticsEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/14/24.
//

// MARK: - TargetAmountEvents

enum TargetAmountEvents: AnalyticsEvent {
    // 목표 금액
    case targetAmountView // 목표 금액 확인 뷰
    case targetAmountHistoryView // 지난 사용 금액 뷰
    case targetAmountInitView // 초기 목표 금액 설정 뷰
    case targetAmountUpdateView // 목표 금액 수정 뷰
    case targetAmountSetCompleteView // 목표 금액 설정 완료 뷰
    
    case postponeTargetAmount // 목표 금액 나중에 설정하기
    case setInitialTargetAmount // 초기 목표 금액 설정하기
    case maintainRecentTargetAmount // 최근 목표 금액 유지
    case cancelRecentTotalAmount // 최근 목표 금액 유지 취소
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .targetAmountView, .targetAmountHistoryView, .targetAmountInitView, .targetAmountUpdateView, .targetAmountSetCompleteView:
            return AnalyticsConstants.EventName.screenView
        case .postponeTargetAmount, .setInitialTargetAmount, .maintainRecentTargetAmount, .cancelRecentTotalAmount:
            return AnalyticsConstants.EventName.btnTapped
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .targetAmountView, .targetAmountHistoryView, .targetAmountInitView, .targetAmountUpdateView, .targetAmountSetCompleteView:
            return AnalyticsConstants.EventType.screenView
        case .postponeTargetAmount, .setInitialTargetAmount, .maintainRecentTargetAmount, .cancelRecentTotalAmount:
            return AnalyticsConstants.EventType.userAction
        }
    }
    
    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .targetAmountView:
            return [
                .screenId: TargetAmountScreen.targetAmountView.screenId,
                .screenName: TargetAmountScreen.targetAmountView.screenName,
                .screenClass: TargetAmountScreen.targetAmountView.screenClass
            ]
        case .targetAmountHistoryView:
            return [
                .screenId: TargetAmountScreen.targetAmountHistoryView.screenId,
                .screenName: TargetAmountScreen.targetAmountHistoryView.screenName,
                .screenClass: TargetAmountScreen.targetAmountHistoryView.screenClass
            ]
        case .targetAmountInitView:
            return [
                .screenId: TargetAmountScreen.targetAmountInitView.screenId,
                .screenName: TargetAmountScreen.targetAmountInitView.screenName,
                .screenClass: TargetAmountScreen.targetAmountInitView.screenClass
            ]
        case .targetAmountUpdateView:
            return [
                .screenId: TargetAmountScreen.targetAmountUpdateView.screenId,
                .screenName: TargetAmountScreen.targetAmountUpdateView.screenName,
                .screenClass: TargetAmountScreen.targetAmountUpdateView.screenClass
            ]
        case .targetAmountSetCompleteView:
            return [
                .screenId: TargetAmountScreen.targetAmountSetCompleteView.screenId,
                .screenName: TargetAmountScreen.targetAmountSetCompleteView.screenName,
                .screenClass: TargetAmountScreen.targetAmountSetCompleteView.screenClass
            ]
        case .postponeTargetAmount:
            return [
                .eventName: TargetAmountCustomEvent.postponeTargetAmount.eventName
            ]
        case .setInitialTargetAmount:
            return [
                .eventName: TargetAmountCustomEvent.setInitialTargetAmount.eventName
            ]
        case .maintainRecentTargetAmount:
            return [
                .eventName: TargetAmountCustomEvent.maintainRecentTargetAmount.eventName
            ]
        case .cancelRecentTotalAmount:
            return [
                .eventName: TargetAmountCustomEvent.cancelRecentTargetAmount.eventName
            ]
        }
    }
}

// MARK: - TargetAmountScreen

enum TargetAmountScreen {
    case targetAmountView
    case targetAmountHistoryView
    case targetAmountInitView
    case targetAmountUpdateView
    case targetAmountSetCompleteView
    
    var screenId: String {
        switch self {
        case .targetAmountView: return "total_amount_view"
        case .targetAmountHistoryView: return "total_amount_history_view"
        case .targetAmountInitView: return "total_amount_init_view"
        case .targetAmountUpdateView: return "total_amount_update_view"
        case .targetAmountSetCompleteView: return "total_amount_set_complete_view"
        }
    }
    
    var screenName: String {
        switch self {
        case .targetAmountView: return "목표 금액 확인 화면"
        case .targetAmountHistoryView: return "지난 사용 금액 화면"
        case .targetAmountInitView: return "초기 목표 금액 설정 화면"
        case .targetAmountUpdateView: return "목표 금액 수정 화면"
        case .targetAmountSetCompleteView: return "목표 금액 설정 완료 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .targetAmountView: return "TotalTargetAmountView"
        case .targetAmountHistoryView: return "PastSpendingListView"
        case .targetAmountInitView: return "TargetAmountSettingView"
        case .targetAmountUpdateView: return "TargetAmountSettingView"
        case .targetAmountSetCompleteView: return "TargetAmountSetCompleteView"
        }
    }
}

// MARK: - TargetAmountCustomEvent

enum TargetAmountCustomEvent {
    case postponeTargetAmount
    case setInitialTargetAmount
    case maintainRecentTargetAmount
    case cancelRecentTargetAmount
    
    var eventName: String {
        switch self {
        case .postponeTargetAmount: return "postpone_target_amount"
        case .setInitialTargetAmount: return "set_initial_target_amount"
        case .maintainRecentTargetAmount: return "maintain_recent_target_amount"
        case .cancelRecentTargetAmount: return "cancel_recent_total_amount"
        }
    }
}
