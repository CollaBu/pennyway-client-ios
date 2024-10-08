// MARK: - SpendingEvents

///
///  SpendingEvents.swift
///  pennyway-client-iOS
///
///  Created by 양재서 on 7/30/24.
///
enum SpendingEvents: AnalyticsEvent {
    case spendingTabView
    case spendingListBottonSheet
    case mySpendingListView
    case spendingDetailView
    case spendingAddView
    case spendingAddCompleteView
    case spendingUpdateView
    case spendAtSelectView
    case spendingListEditView
    case spendingEditdonePopup
    case spendingEditDeletePopUp
    case spendingDeletePopUp

    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .spendingTabView, .spendingListBottonSheet, .mySpendingListView, .spendingDetailView, .spendingAddView, .spendingAddCompleteView, .spendingUpdateView, .spendingListEditView, .spendAtSelectView, .spendingEditdonePopup, .spendingEditDeletePopUp, .spendingDeletePopUp:
            return AnalyticsConstants.EventName.screenView
        }
    }

    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .spendingTabView, .spendingListBottonSheet, .mySpendingListView, .spendingDetailView, .spendingAddView, .spendingAddCompleteView, .spendingUpdateView, .spendAtSelectView, .spendingListEditView, .spendingEditdonePopup, .spendingEditDeletePopUp, .spendingDeletePopUp:
            return AnalyticsConstants.EventType.screenView
        }
    }

    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .spendingTabView:
            return [
                .screenId: SpendingScreen.spendingTabView.screenId,
                .screenName: SpendingScreen.spendingTabView.screenName,
                .screenClass: SpendingScreen.spendingTabView.screenClass,
            ]
        case .spendingListBottonSheet:
            return [
                .screenId: SpendingScreen.spendingListBottonSheet.screenId,
                .screenName: SpendingScreen.spendingListBottonSheet.screenName,
                .screenClass: SpendingScreen.spendingListBottonSheet.screenClass,
            ]
        case .mySpendingListView:
            return [
                .screenId: SpendingScreen.mySpendingListView.screenId,
                .screenName: SpendingScreen.mySpendingListView.screenName,
                .screenClass: SpendingScreen.mySpendingListView.screenClass,
            ]
        case .spendingDetailView:
            return [
                .screenId: SpendingScreen.spendingDetailView.screenId,
                .screenName: SpendingScreen.spendingDetailView.screenName,
                .screenClass: SpendingScreen.spendingDetailView.screenClass,
            ]
        case .spendingAddView:
            return [
                .screenId: SpendingScreen.spendingAddView.screenId,
                .screenName: SpendingScreen.spendingAddView.screenName,
                .screenClass: SpendingScreen.spendingAddView.screenClass,
            ]
        case .spendingAddCompleteView:
            return [
                .screenId: SpendingScreen.spendingAddCompleteView.screenId,
                .screenName: SpendingScreen.spendingAddCompleteView.screenName,
                .screenClass: SpendingScreen.spendingAddCompleteView.screenClass,
            ]
        case .spendingUpdateView:
            return [
                .screenId: SpendingScreen.spendingUpdateView.screenId,
                .screenName: SpendingScreen.spendingUpdateView.screenName,
                .screenClass: SpendingScreen.spendingUpdateView.screenClass,
            ]
        case .spendAtSelectView:
            return [
                .screenId: SpendingScreen.spendAtSelectView.screenId,
                .screenName: SpendingScreen.spendAtSelectView.screenName,
                .screenClass: SpendingScreen.spendAtSelectView.screenClass,
            ]
        case .spendingListEditView:
            return [
                .screenId: SpendingScreen.spendingListEditView.screenId,
                .screenName: SpendingScreen.spendingListEditView.screenName,
                .screenClass: SpendingScreen.spendingListEditView.screenClass,
            ]
        case .spendingEditdonePopup:
            return [
                .screenId: SpendingScreen.spendingEditdonePopup.screenId,
                .screenName: SpendingScreen.spendingEditdonePopup.screenName,
                .screenClass: SpendingScreen.spendingEditdonePopup.screenClass,
            ]
        case .spendingEditDeletePopUp:
            return [
                .screenId: SpendingScreen.spendingEditDeletePopUp.screenId,
                .screenName: SpendingScreen.spendingEditDeletePopUp.screenName,
                .screenClass: SpendingScreen.spendingEditDeletePopUp.screenClass,
            ]
        case .spendingDeletePopUp:
            return [
                .screenId: SpendingScreen.spendingDeletePopUp.screenId,
                .screenName: SpendingScreen.spendingDeletePopUp.screenName,
                .screenClass: SpendingScreen.spendingDeletePopUp.screenClass,
            ]
        }
    }
}

// MARK: - SpendingScreen

enum SpendingScreen {
    case spendingTabView
    case spendingListBottonSheet
    case mySpendingListView
    case spendingDetailView
    case spendingAddView
    case spendingAddCompleteView
    case spendingUpdateView
    case spendAtSelectView
    case spendingListEditView
    case spendingEditdonePopup
    case spendingEditDeletePopUp
    case spendingDeletePopUp

    var screenId: String {
        switch self {
        case .spendingTabView: return "spending_tab_view"
        case .spendingListBottonSheet: return "spending_bottom_sheet_view"
        case .mySpendingListView: return "my_spending_list_view"
        case .spendingDetailView: return "spending_detail_view"
        case .spendingAddView: return "spending_add_view"
        case .spendingAddCompleteView: return "spending_add_complete_view"
        case .spendingUpdateView: return "spending_update_view"
        case .spendAtSelectView: return "spend_at_select_view"
        case .spendingListEditView: return "spending_list_edit_view"
        case .spendingEditdonePopup: return "spending_edit_done_popup"
        case .spendingEditDeletePopUp: return "spending_edit_delete_popup"
        case .spendingDeletePopUp: return "spending_delete_popup"
        }
    }

    var screenName: String {
        switch self {
        case .spendingTabView: return "지출 관리 메인 탭 화면"
        case .spendingListBottonSheet: return "지출 관리 바텀시트 화면"
        case .mySpendingListView: return "나의 소비 내역 화면"
        case .spendingDetailView: return "지출 상세 화면"
        case .spendingAddView: return "소비 내역 추가하기 화면"
        case .spendingAddCompleteView: return "소비 내역 추가 완료 화면"
        case .spendingUpdateView: return "소비 내역 수정 화면"
        case .spendAtSelectView: return "소비 날짜 선택 화면"
        case .spendingListEditView: return "소비 내역 편집하기 화면"
        case .spendingEditdonePopup: return "소비 내역 편집 끝내기 팝업"
        case .spendingEditDeletePopUp: return "소비 내역 다중 삭제 팝업"
        case .spendingDeletePopUp: return "소비 내역 삭제 팝업"
        }
    }

    var screenClass: String {
        switch self {
        case .spendingTabView: return "SpendingManagementMainView"
        case .spendingListBottonSheet: return "SpendingDetailSheetView"
        case .mySpendingListView: return "MySpendingListView"
        case .spendingDetailView: return "DetailSpendingView"
        case .spendingAddView: return "AddSpendingInputFormView"
        case .spendingAddCompleteView: return "AddSpendingCompleteView"
        case .spendingUpdateView: return "AddSpendingInputFormView"
        case .spendAtSelectView: return "SelectSpendingDayView"
        case .spendingListEditView: return "SpendingDetailSheetView"
        case .spendingEditdonePopup: return "SpendingDetailSheetView"
        case .spendingEditDeletePopUp: return "SpendingDetailSheetView"
        case .spendingDeletePopUp: return "DetailSpendingView"
        }
    }
}
