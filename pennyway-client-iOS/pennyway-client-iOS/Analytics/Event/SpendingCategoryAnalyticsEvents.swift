//
//  SpendingCategoryAnalyticsEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/14/24.
//

// MARK: - SpendingCategoryEvents

enum SpendingCategoryEvents: AnalyticsEvent {
    case categorySelectView
    case categoryAddView
    case iconSelectView
    case categoryListView
    case categoryDetailView
    case categoryUpdateView
    case categoryDeletePopUp
    case categoryMigrateView
    case categoryMigratePopUp

    case migrateSpendingList
    case deleteCategoryList

    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .categorySelectView, .categoryAddView, .iconSelectView, .categoryListView, .categoryDetailView, .categoryUpdateView, .categoryDeletePopUp, .categoryMigrateView, .categoryMigratePopUp:
            return AnalyticsConstants.EventName.screenView
        case .migrateSpendingList, .deleteCategoryList:
            return AnalyticsConstants.EventName.btnTapped
        }
    }

    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .categorySelectView, .categoryAddView, .iconSelectView, .categoryListView, .categoryDetailView, .categoryUpdateView, .categoryDeletePopUp, .categoryMigrateView, .categoryMigratePopUp:
            return AnalyticsConstants.EventType.screenView
        case .migrateSpendingList, .deleteCategoryList:
            return AnalyticsConstants.EventType.userAction
        }
    }

    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .categorySelectView:
            return [
                .screenId: SpendingCategoryScreen.categorySelectView.screenId,
                .screenName: SpendingCategoryScreen.categorySelectView.screenName,
                .screenClass: SpendingCategoryScreen.categorySelectView.screenClass,
            ]
        case .categoryAddView:
            return [
                .screenId: SpendingCategoryScreen.categoryAddView.screenId,
                .screenName: SpendingCategoryScreen.categoryAddView.screenName,
                .screenClass: SpendingCategoryScreen.categoryAddView.screenClass,
            ]
        case .iconSelectView:
            return [
                .screenId: SpendingCategoryScreen.iconSelectView.screenId,
                .screenName: SpendingCategoryScreen.iconSelectView.screenName,
                .screenClass: SpendingCategoryScreen.iconSelectView.screenClass,
            ]
        case .categoryListView:
            return [
                .screenId: SpendingCategoryScreen.categoryListView.screenId,
                .screenName: SpendingCategoryScreen.categoryListView.screenName,
                .screenClass: SpendingCategoryScreen.categoryListView.screenClass,
            ]
        case .categoryDetailView:
            return [
                .screenId: SpendingCategoryScreen.categoryDetailView.screenId,
                .screenName: SpendingCategoryScreen.categoryDetailView.screenName,
                .screenClass: SpendingCategoryScreen.categoryDetailView.screenClass,
            ]
        case .categoryUpdateView:
            return [
                .screenId: SpendingCategoryScreen.categoryUpdateView.screenId,
                .screenName: SpendingCategoryScreen.categoryUpdateView.screenName,
                .screenClass: SpendingCategoryScreen.categoryUpdateView.screenClass,
            ]
        case .categoryDeletePopUp:
            return [
                .screenId: SpendingCategoryScreen.categoryDeletePopUp.screenId,
                .screenName: SpendingCategoryScreen.categoryDeletePopUp.screenName,
                .screenClass: SpendingCategoryScreen.categoryDeletePopUp.screenClass,
            ]
        case .categoryMigrateView:
            return [
                .screenId: SpendingCategoryScreen.categoryMigrateView.screenId,
                .screenName: SpendingCategoryScreen.categoryMigrateView.screenName,
                .screenClass: SpendingCategoryScreen.categoryMigrateView.screenClass,
            ]
        case .categoryMigratePopUp:
            return [
                .screenId: SpendingCategoryScreen.categoryMigratePopUp.screenId,
                .screenName: SpendingCategoryScreen.categoryMigratePopUp.screenName,
                .screenClass: SpendingCategoryScreen.categoryMigratePopUp.screenClass,
            ]
        case .migrateSpendingList:
            return [
                .eventName: SpendingCategoryCustomEvent.migrateSpendingList.eventName,
            ]
        case .deleteCategoryList:
            return [
                .eventName: SpendingCategoryCustomEvent.deleteCategoryList.eventName,
            ]
        }
    }
}

// MARK: - SpendingCategoryScreen

enum SpendingCategoryScreen {
    case categorySelectView
    case categoryAddView
    case iconSelectView
    case categoryListView
    case categoryDetailView
    case categoryUpdateView
    case categoryDeletePopUp
    case categoryMigrateView
    case categoryMigratePopUp

    var screenId: String {
        switch self {
        case .categorySelectView: return "category_select_view"
        case .categoryAddView: return "category_add_view"
        case .iconSelectView: return "icon_select_view"
        case .categoryListView: return "category_list_view"
        case .categoryDetailView: return "category_detail_view"
        case .categoryUpdateView: return "category_update_view"
        case .categoryDeletePopUp: return "category_delete_view"
        case .categoryMigrateView: return "category_migrate_view"
        case .categoryMigratePopUp: return "category_migrate_pop_up"
        }
    }

    var screenName: String {
        switch self {
        case .categorySelectView: return "카테고리 선택 화면"
        case .categoryAddView: return "카테고리 추가 화면"
        case .iconSelectView: return "아이콘 선택 화면"
        case .categoryListView: return "카테고리 리스트 화면"
        case .categoryDetailView: return "카테고리 상세 화면"
        case .categoryUpdateView: return "카테고리 수정 화면"
        case .categoryDeletePopUp: return "카테고리 삭제 화면"
        case .categoryMigrateView: return "카테고리 내 소비내역 옮기기 화면"
        case .categoryMigratePopUp: return "카테고리 내 소비내역 옮기기 팝업"
        }
    }

    var screenClass: String {
        switch self {
        case .categorySelectView: return "SpendingCategoryListView"
        case .categoryAddView: return "AddSpendingCategoryView"
        case .iconSelectView: return "SelectCategoryIconView"
        case .categoryListView: return "SpendingCategoryGridView"
        case .categoryDetailView: return "CategoryDetailView"
        case .categoryUpdateView: return "AddSpendingCategoryView"
        case .categoryDeletePopUp: return "CategoryDetailsPopUp"
        case .categoryMigrateView: return "MoveCategoryView"
        case .categoryMigratePopUp: return "MoveCategoryView"
        }
    }
}

// MARK: - SpendingCategoryCustomEvent

enum SpendingCategoryCustomEvent {
    case migrateSpendingList
    case deleteCategoryList

    var eventName: String {
        switch self {
        case .migrateSpendingList: return "migrate_spending_list"
        case .deleteCategoryList: return "delete_category_list"
        }
    }
}
