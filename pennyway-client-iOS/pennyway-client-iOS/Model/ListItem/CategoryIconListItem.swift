
import Foundation

// MARK: - CategoryIconListItem

struct CategoryIconListItem: Identifiable {
    let id = UUID()
    let offIcon: CategoryIconName
    let onIcon: CategoryIconName
}

// MARK: - IconState

enum IconState: String {
    case off
    case on
    case onWhite = "on_white"
    case onMint = "on_mint"
}

// MARK: - CategoryIconName

struct CategoryIconName: Hashable {
    let baseName: CategoryBaseName
    let state: IconState

    var rawValue: String {
        return "icon_category_\(baseName)_\(state.rawValue)"
    }
}

// MARK: - SpendingCategoryData

struct SpendingCategoryData: Identifiable {
    let id: Int
    let isCustom: Bool
    var name: String
    var icon: CategoryIconName
}

// MARK: - CategoryBaseName

enum CategoryBaseName: String {
    case food
    case traffic
    case beauty
    case market
    case education
    case life
    case health
    case hobby
    case travel
    case drink
    case event
    case etc
    case plus
}

// MARK: - SpendingCategoryIconList

enum SpendingCategoryIconList: String, CaseIterable {
    case food = "FOOD"
    case transportation = "TRANSPORTATION"
    case beautyOrFashion = "BEAUTY_OR_FASHION"
    case convenienceStore = "CONVENIENCE_STORE"
    case education = "EDUCATION"
    case living = "LIVING"
    case health = "HEALTH"
    case hobby = "HOBBY"
    case travel = "TRAVEL"
    case alcoholOrEntertainment = "ALCOHOL_OR_ENTERTAINMENT"
    case membershipOrFamilyEvent = "MEMBERSHIP_OR_FAMILY_EVENT"
    case other = "OTHER"
    case plus = "PLUS"

    var baseName: CategoryBaseName {
        switch self {
        case .food: return .food
        case .transportation: return .traffic
        case .beautyOrFashion: return .beauty
        case .convenienceStore: return .market
        case .education: return .education
        case .living: return .life
        case .health: return .health
        case .hobby: return .hobby
        case .travel: return .travel
        case .alcoholOrEntertainment: return .drink
        case .membershipOrFamilyEvent: return .event
        case .other: return .etc
        case .plus: return .plus
        }
    }

    var id: Int {
        switch self {
        case .food: return -1
        case .transportation: return -2
        case .beautyOrFashion: return -3
        case .convenienceStore: return -4
        case .education: return -5
        case .living: return -6
        case .health: return -7
        case .hobby: return -8
        case .travel: return -9
        case .alcoholOrEntertainment: return -10
        case .membershipOrFamilyEvent: return -11
        case .other: return -12
        case .plus: return -13
        }
    }

    var displayName: String {
        switch self {
        case .food: return "식비"
        case .transportation: return "교통"
        case .beautyOrFashion: return "미용/패션"
        case .convenienceStore: return "편의점/마트"
        case .education: return "교육"
        case .living: return "생활"
        case .health: return "건강"
        case .hobby: return "취미/여가"
        case .travel: return "여행/숙박"
        case .alcoholOrEntertainment: return "술/유흥"
        case .membershipOrFamilyEvent: return "회비/경조사"
        case .other: return "기타"
        case .plus: return "추가하기"
        }
    }

    var details: SpendingCategoryData {
        let icon: CategoryIconName
        if self == .plus {
            icon = CategoryIconName(baseName: .plus, state: .off)
        } else {
            icon = CategoryIconName(baseName: baseName, state: .on)
        }
        return SpendingCategoryData(id: id, isCustom: false, name: displayName, icon: icon)
    }

    var detailsWhite: SpendingCategoryData {
        let icon: CategoryIconName
        if self == .plus {
            icon = CategoryIconName(baseName: .plus, state: .off)
        } else {
            icon = CategoryIconName(baseName: baseName, state: .onWhite)
        }
        return SpendingCategoryData(id: id, isCustom: false, name: displayName, icon: icon)
    }

    static func fromIcon(_ icon: CategoryIconName) -> SpendingCategoryIconList? {
        return SpendingCategoryIconList.allCases.first { $0.baseName == icon.baseName }
    }
}

// MARK: - SpendingListViewCategoryIconList

/// 소비내역 상세조회 카테고리 리스트
enum SpendingListViewCategoryIconList: String, CaseIterable, Identifiable {
    case food = "FOOD"
    case transportation = "TRANSPORTATION"
    case beautyOrFashion = "BEAUTY_OR_FASHION"
    case convenienceStore = "CONVENIENCE_STORE"
    case education = "EDUCATION"
    case living = "LIVING"
    case health = "HEALTH"
    case hobby = "HOBBY"
    case travel = "TRAVEL"
    case alcoholOrEntertainment = "ALCOHOL_OR_ENTERTAINMENT"
    case membershipOrFamilyEvent = "MEMBERSHIP_OR_FAMILY_EVENT"
    case other = "OTHER"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .food:
            return "icon_category_food_on"
        case .transportation:
            return "icon_category_traffic_on"
        case .beautyOrFashion:
            return "icon_category_beauty_on"
        case .convenienceStore:
            return "icon_category_market_on"
        case .education:
            return "icon_category_education_on"
        case .living:
            return "icon_category_life_on"
        case .health:
            return "icon_category_health_on"
        case .hobby:
            return "icon_category_hobby_on"
        case .travel:
            return "icon_category_travel_on"
        case .alcoholOrEntertainment:
            return "icon_category_drink_on"
        case .membershipOrFamilyEvent:
            return "icon_category_event_on"
        case .other:
            return "icon_category_etc_on"
        }
    }
}
