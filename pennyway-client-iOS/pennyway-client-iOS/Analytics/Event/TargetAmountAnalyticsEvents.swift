//
//  TargetAmountAnalyticsEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/14/24.
//

enum TargetAmountEvents: AnalyticsEvent {
    // 목표 금액
    case totalAmountView // 목표 금액 확인 뷰
    case totalAmountHistoryView // 지난 사용 금액 뷰
    case totalAmountInitView // 초기 목표 금액 설정 뷰
    case totalAmountUpdateView // 목표 금액 수정 뷰
    
    case maintainRecentTargetAmount // 최근 목표 금액 유지
    case cancelRecentTotalAmount // 최근 목표 금액 유지 취소
}

enum TargetAmountScreen {
    case totalAmountView
    case totalAmountHistoryView
    case totalAmountInitView
    case totalAmountUpdateView
    
    var screenId: String {
        switch self {
        case .totalAmountView: return "total_amount_view"
        case .totalAmountHistoryView: return "total_amount_history_view"
        case .totalAmountInitView: return "total_amount_init_view"
        case .totalAmountUpdateView: return "total_amount_update_view"
        }
    }
    
    var screenName: String {
        switch self {
        case .totalAmountView: return "목표 금액 확인 화면"
        case .totalAmountHistoryView: return "지난 사용 금액 화면"
        case .totalAmountInitView: return "초기 목표 금액 설정 화면"
        case .totalAmountUpdateView: return "목표 금액 수정 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .totalAmountView: return ""
        case .totalAmountHistoryView: return ""
        case .totalAmountInitView: return ""
        case .totalAmountUpdateView: return ""
        }
    }
}

enum TargetAmountCustomEvent {
    case maintainRecentTargetAmount
    case cancelRecentTotalAmount
    
    var eventName: String {
        switch self {
        case .maintainRecentTargetAmount: return "maintain_recent_target_amount"
        case .cancelRecentTotalAmount: return "cancel_recent_total_amount"
        }
    }
}
