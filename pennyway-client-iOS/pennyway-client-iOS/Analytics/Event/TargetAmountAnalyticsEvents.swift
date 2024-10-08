//
//  TargetAmountAnalyticsEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/14/24.
//

// MARK: - TargetAmountEvents

enum TargetAmountEvents: AnalyticsEvent {
    case targetAmountView
    case targetAmountHistoryView
    case targetAmountInitView
    case targetAmountUpdateView
    case targetAmountSetCompleteView

    case postponeTargetAmount
    case setInitialTargetAmount
    case maintainRecentTargetAmount
    case cancelRecentTotalAmount

    case targetAmountResetPopUp

    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .targetAmountView, .targetAmountHistoryView, .targetAmountInitView, .targetAmountUpdateView, .targetAmountSetCompleteView, .targetAmountResetPopUp:
            return AnalyticsConstants.EventName.screenView
        case .postponeTargetAmount, .setInitialTargetAmount, .maintainRecentTargetAmount, .cancelRecentTotalAmount:
            return AnalyticsConstants.EventName.btnTapped
        }
    }

    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .targetAmountView, .targetAmountHistoryView, .targetAmountInitView, .targetAmountUpdateView, .targetAmountSetCompleteView, .targetAmountResetPopUp:
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
                .screenClass: TargetAmountScreen.targetAmountView.screenClass,
            ]
        case .targetAmountHistoryView:
            return [
                .screenId: TargetAmountScreen.targetAmountHistoryView.screenId,
                .screenName: TargetAmountScreen.targetAmountHistoryView.screenName,
                .screenClass: TargetAmountScreen.targetAmountHistoryView.screenClass,
            ]
        case .targetAmountInitView:
            return [
                .screenId: TargetAmountScreen.targetAmountInitView.screenId,
                .screenName: TargetAmountScreen.targetAmountInitView.screenName,
                .screenClass: TargetAmountScreen.targetAmountInitView.screenClass,
            ]
        case .targetAmountUpdateView:
            return [
                .screenId: TargetAmountScreen.targetAmountUpdateView.screenId,
                .screenName: TargetAmountScreen.targetAmountUpdateView.screenName,
                .screenClass: TargetAmountScreen.targetAmountUpdateView.screenClass,
            ]
        case .targetAmountSetCompleteView:
            return [
                .screenId: TargetAmountScreen.targetAmountSetCompleteView.screenId,
                .screenName: TargetAmountScreen.targetAmountSetCompleteView.screenName,
                .screenClass: TargetAmountScreen.targetAmountSetCompleteView.screenClass,
            ]
        case .targetAmountResetPopUp:
            return [
                .screenId: TargetAmountScreen.targetAmountResetPopUp.screenId,
                .screenName: TargetAmountScreen.targetAmountResetPopUp.screenName,
                .screenClass: TargetAmountScreen.targetAmountResetPopUp.screenClass,
            ]
        case .postponeTargetAmount:
            return [
                .eventName: TargetAmountCustomEvent.postponeTargetAmount.eventName,
            ]
        case .setInitialTargetAmount:
            return [
                .eventName: TargetAmountCustomEvent.setInitialTargetAmount.eventName,
            ]
        case .maintainRecentTargetAmount:
            return [
                .eventName: TargetAmountCustomEvent.maintainRecentTargetAmount.eventName,
            ]
        case .cancelRecentTotalAmount:
            return [
                .eventName: TargetAmountCustomEvent.cancelRecentTargetAmount.eventName,
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
    case targetAmountResetPopUp

    var screenId: String {
        switch self {
        case .targetAmountView: return "total_amount_view"
        case .targetAmountHistoryView: return "total_amount_history_view"
        case .targetAmountInitView: return "total_amount_init_view"
        case .targetAmountUpdateView: return "total_amount_update_view"
        case .targetAmountSetCompleteView: return "total_amount_set_complete_view"
        case .targetAmountResetPopUp: return "total_amount_reset_popup"
        }
    }

    var screenName: String {
        switch self {
        case .targetAmountView: return "목표 금액 확인 화면"
        case .targetAmountHistoryView: return "지난 사용 금액 화면"
        case .targetAmountInitView: return "초기 목표 금액 설정 화면"
        case .targetAmountUpdateView: return "목표 금액 수정 화면"
        case .targetAmountSetCompleteView: return "목표 금액 설정 완료 화면"
        case .targetAmountResetPopUp: return "목표 금액 초기화 팝업"
        }
    }

    var screenClass: String {
        switch self {
        case .targetAmountView: return "TotalTargetAmountView"
        case .targetAmountHistoryView: return "PastSpendingListView"
        case .targetAmountInitView: return "TargetAmountSettingView"
        case .targetAmountUpdateView: return "TargetAmountSettingView"
        case .targetAmountSetCompleteView: return "TargetAmountSetCompleteView"
        case .targetAmountResetPopUp: return "TotalTargetAmountView"
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
