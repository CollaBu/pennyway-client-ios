// MARK: - SpendingEvents

///
///  SpendingEvents.swift
///  pennyway-client-iOS
///
///  Created by 양재서 on 7/30/24.
///
enum SpendingEvents: AnalyticsEvent {
    case spendingTabView // 지출 관리 메인 탭뷰
    case spendingBottomSheetView // 지출 관리 바텀시트 뷰 (날짜 파라미터 필요)
    case mySpendingListView // 나의 소비 내역 뷰 (날짜 파라미터 필요)
    case spendingDetailView // 지출 상세 뷰
    case spendingAddView // 소비 내역 추가하기 뷰
    case spendingAddCompleteView // 소비 내역 추가 완료 뷰
    case spendingUpdateView // 소비 내역 수정 뷰
    case spendingListEditView // 소비 내역 편집하기 뷰 (바텀시트)
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .spendingTabView, .spendingBottomSheetView, .mySpendingListView, .spendingDetailView, .spendingAddView, .spendingAddCompleteView, .spendingUpdateView, .spendingListEditView:
            return AnalyticsConstants.EventName.screenView
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .spendingTabView, .spendingBottomSheetView, .mySpendingListView, .spendingDetailView, .spendingAddView, .spendingAddCompleteView, .spendingUpdateView, .spendingListEditView:
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
            case .spendingBottomSheetView:
                return [
                    .screenId: SpendingScreen.spendingBottomSheetView.screenId,
                    .screenName: SpendingScreen.spendingBottomSheetView.screenName,
                    .screenClass: SpendingScreen.spendingBottomSheetView.screenClass
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
    case spendingTabView // 지출 관리 메인 탭뷰
    case spendingBottomSheetView // 지출 관리 바텀시트 뷰 (날짜 파라미터 필요)
    case mySpendingListView // 나의 소비 내역 뷰 (날짜 파라미터 필요)
    case spendingDetailView // 지출 상세 뷰
    case spendingAddView // 소비 내역 추가하기 뷰
    case spendingAddCompleteView // 소비 내역 추가 완료 뷰
    case spendingUpdateView // 소비 내역 수정 뷰
    case spendingListEditView // 소비 내역 편집하기 뷰 (바텀시트)
    
    var screenId: String {
        switch self {
            case .spendingTabView: return "spending_tab_view"
            case .spendingBottomSheetView: return "spending_bottom_sheet_view"
            case .mySpendingListView: return "my_spending_list_view"
            case .spendingDetailView: return "spending_detail_view"
            case .spendingAddView: return "spending_add_view"
            case .spendingAddCompleteView: return "spending_add_complete_view"
            case .spendingUpdateView: return "spending_update_view"
            case .spendingListEditView: return "spending_list_edit_view"
        }
    }
    
    var screenName: String {
        switch self {
            case .spendingTabView: return "지출 관리 메인 탭 화면"
            case .spendingBottomSheetView: return "지출 관리 바텀시트 화면"
            case .mySpendingListView: return "나의 소비 내역 화면"
            case .spendingDetailView: return "지출 상세 화면"
            case .spendingAddView: return "소비 내역 추가하기 화면"
            case .spendingAddCompleteView: return "소비 내역 추가 완료 화면"
            case .spendingUpdateView: return "소비 내역 수정 화면"
            case .spendingListEditView: return "소비 내역 편집하기 화면"
        }
    }
    
    var screenClass: String {
        switch self {
            case .spendingTabView: return ""
            case .spendingBottomSheetView: return ""
            case .mySpendingListView: return ""
            case .spendingDetailView: return ""
            case .spendingAddView: return ""
            case .spendingAddCompleteView: return ""
            case .spendingUpdateView: return ""
            case .spendingListEditView: return ""
        }
    }
}
