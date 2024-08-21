// MARK: - SpendingEvents

///
///  SpendingEvents.swift
///  pennyway-client-iOS
///
///  Created by 양재서 on 7/30/24.
///
enum SpendingEvents: AnalyticsEvent {
    case spendingTabView
    case spendingListView
    case mySpendingListView
    case spendingDetailView
    case spendingAddView
    case spendingAddCompleteView
    case spendingUpdateView
    case spendAtSelectView
    case spendingListEditView
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .spendingTabView, .spendingListView, .mySpendingListView, .spendingDetailView, .spendingAddView, .spendingAddCompleteView, .spendingUpdateView, .spendingListEditView, .spendAtSelectView:
            return AnalyticsConstants.EventName.screenView
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .spendingTabView, .spendingListView, .mySpendingListView, .spendingDetailView, .spendingAddView, .spendingAddCompleteView, .spendingUpdateView, .spendAtSelectView, .spendingListEditView:
            return AnalyticsConstants.EventType.screenView
        }
    }
    
    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .spendingTabView:
            return [
                .screenId: SpendingScreen.spendingTabView.screenId,
                .screenName: SpendingScreen.spendingTabView.screenName,
                .screenClass: SpendingScreen.spendingTabView.screenClass
            ]
        case .spendingListView:
            return [
                .screenId: SpendingScreen.spendingListView.screenId,
                .screenName: SpendingScreen.spendingListView.screenName,
                .screenClass: SpendingScreen.spendingListView.screenClass
            ]
        case .mySpendingListView:
            return [
                .screenId: SpendingScreen.mySpendingListView.screenId,
                .screenName: SpendingScreen.mySpendingListView.screenName,
                .screenClass: SpendingScreen.mySpendingListView.screenClass
            ]
        case .spendingDetailView:
            return [
                .screenId: SpendingScreen.spendingDetailView.screenId,
                .screenName: SpendingScreen.spendingDetailView.screenName,
                .screenClass: SpendingScreen.spendingDetailView.screenClass
            ]
        case .spendingAddView:
            return [
                .screenId: SpendingScreen.spendingAddView.screenId,
                .screenName: SpendingScreen.spendingAddView.screenName,
                .screenClass: SpendingScreen.spendingAddView.screenClass
            ]
        case .spendingAddCompleteView:
            return [
                .screenId: SpendingScreen.spendingAddCompleteView.screenId,
                .screenName: SpendingScreen.spendingAddCompleteView.screenName,
                .screenClass: SpendingScreen.spendingAddCompleteView.screenClass
            ]
        case .spendingUpdateView:
            return [
                .screenId: SpendingScreen.spendingUpdateView.screenId,
                .screenName: SpendingScreen.spendingUpdateView.screenName,
                .screenClass: SpendingScreen.spendingUpdateView.screenClass
            ]
        case .spendAtSelectView:
            return [
                .screenId: SpendingScreen.spendAtSelectView.screenId,
                .screenName: SpendingScreen.spendAtSelectView.screenName,
                .screenClass: SpendingScreen.spendAtSelectView.screenClass
            ]
        case .spendingListEditView:
            return [
                .screenId: SpendingScreen.spendingListEditView.screenId,
                .screenName: SpendingScreen.spendingListEditView.screenName,
                .screenClass: SpendingScreen.spendingListEditView.screenClass
            ]
        }
    }
}

// MARK: - SpendingScreen

enum SpendingScreen {
    case spendingTabView
    case spendingListView
    case mySpendingListView
    case spendingDetailView
    case spendingAddView
    case spendingAddCompleteView
    case spendingUpdateView
    case spendAtSelectView
    case spendingListEditView
    
    var screenId: String {
        switch self {
        case .spendingTabView: return "spending_tab_view"
        case .spendingListView: return "spending_bottom_sheet_view"
        case .mySpendingListView: return "my_spending_list_view"
        case .spendingDetailView: return "spending_detail_view"
        case .spendingAddView: return "spending_add_view"
        case .spendingAddCompleteView: return "spending_add_complete_view"
        case .spendingUpdateView: return "spending_update_view"
        case .spendAtSelectView: return "spend_at_select_view"
        case .spendingListEditView: return "spending_list_edit_view"
        }
    }
    
    var screenName: String {
        switch self {
        case .spendingTabView: return "지출 관리 메인 탭 화면"
        case .spendingListView: return "지출 관리 바텀시트 화면"
        case .mySpendingListView: return "나의 소비 내역 화면"
        case .spendingDetailView: return "지출 상세 화면"
        case .spendingAddView: return "소비 내역 추가하기 화면"
        case .spendingAddCompleteView: return "소비 내역 추가 완료 화면"
        case .spendingUpdateView: return "소비 내역 수정 화면"
        case .spendAtSelectView: return "소비 날짜 선택 화면"
        case .spendingListEditView: return "소비 내역 편집하기 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .spendingTabView: return "SpendingManagementMainView"
        case .spendingListView: return "SpendingDetailSheetView"
        case .mySpendingListView: return "MySpendingListView"
        case .spendingDetailView: return "DetailSpendingView"
        case .spendingAddView: return "AddSpendingInputFormView"
        case .spendingAddCompleteView: return "AddSpendingCompleteView"
        case .spendingUpdateView: return "AddSpendingInputFormView"
        case .spendAtSelectView: return "SelectSpendingDayView"
        case .spendingListEditView: return "SpendingDetailSheetView"
        }
    }
}
