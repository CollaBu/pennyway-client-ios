
import Foundation

// MARK: - CategoryIconListItem

struct CategoryIconListItem: Identifiable {
    let id = UUID()
    let offIcon: CategoryIconName
    let onIcon: CategoryIconName
}

// MARK: - CategoryIconName

enum CategoryIconName: String {
    case foodOff = "icon_category_food_off"
    case foodOn = "icon_category_food_on"
    case foodOnWhite = "icon_category_food_on_white"
    case foodOnMint = "icon_category_food_on_mint"
    case trafficOff = "icon_category_traffic_off"
    case trafficOn = "icon_category_traffic_on"
    case trafficOnWhite = "icon_category_traffic_on_white"
    case trafficOnMint = "icon_category_traffic_on_mint"
    case beautyOff = "icon_category_beauty_off"
    case beautyOn = "icon_category_beauty_on"
    case beautyOnWhite = "icon_category_beauty_on_white"
    case beautyOnMint = "icon_category_beauty_on_mint"
    case marketOff = "icon_category_market_off"
    case marketOn = "icon_category_market_on"
    case marketOnWhite = "icon_category_market_on_white"
    case marketOnMint = "icon_category_market_on_mint"
    case educationOff = "icon_category_education_off"
    case educationOn = "icon_category_education_on"
    case educationOnWhite = "icon_category_education_on_white"
    case educationOnMint = "icon_category_education_on_mint"
    case lifeOff = "icon_category_life_off"
    case lifeOn = "icon_category_life_on"
    case lifeOnWhite = "icon_category_life_on_white"
    case lifeOnMint = "icon_category_life_on_mint"
    case healthOff = "icon_category_health_off"
    case healthOn = "icon_category_health_on"
    case healthOnWhite = "icon_category_health_on_white"
    case healthOnMint = "icon_category_health_on_mint"
    case hobbyOff = "icon_category_hobby_off"
    case hobbyOn = "icon_category_hobby_on"
    case hobbyOnWhite = "icon_category_hobby_on_white"
    case hobbyOnMint = "icon_category_hobby_on_mint"
    case travelOff = "icon_category_travel_off"
    case travelOn = "icon_category_travel_on"
    case travelOnWhite = "icon_category_travel_on_white"
    case travelOnMint = "icon_category_travel_on_mint"
    case drinkOff = "icon_category_drink_off"
    case drinkOn = "icon_category_drink_on"
    case drinkOnWhite = "icon_category_drink_on_white"
    case drinkOnMint = "icon_category_drink_on_mint"
    case eventOff = "icon_category_event_off"
    case eventOn = "icon_category_event_on"
    case eventOnWhite = "icon_category_event_on_white"
    case eventOnMint = "icon_category_event_on_mint"
    case etcOff = "icon_category_etc_off"
    case etcOn = "icon_category_etc_on"
    case etcOnWhite = "icon_category_etc_on_white"
    case etcOnMint = "icon_category_etc_on_mint"
    case plusOff = "icon_category_plus_off"
}

// MARK: - IconState

enum IconState: String {
    case off = "off"
    case on = "on"
    case onWhite = "on_white"
    case onMint = "on_mint"
}

// MARK: - SpendingCategoryData

struct SpendingCategoryData: Identifiable {
    let id: Int
    let isCustom: Bool
    let name: String
    let icon: CategoryIconName
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

    var baseName: String {
        switch self {
        case .food: return "food"
        case .transportation: return "traffic"
        case .beautyOrFashion: return "beauty"
        case .convenienceStore: return "market"
        case .education: return "education"
        case .living: return "life"
        case .health: return "health"
        case .hobby: return "hobby"
        case .travel: return "travel"
        case .alcoholOrEntertainment: return "drink"
        case .membershipOrFamilyEvent: return "event"
        case .other: return "etc"
        case .plus: return "plus"
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
        let iconName: String
        if self == .plus {
            iconName = "icon_category_plus_off"
        } else {
            iconName = "icon_category_\(baseName)_\(IconState.on.rawValue)"
        }
        return SpendingCategoryData(id: id, isCustom: false, name: displayName, icon: CategoryIconName(rawValue: iconName)!)
    }

    var detailsWhite: SpendingCategoryData {
        let iconName: String
        if self == .plus {
            iconName = "icon_category_plus_off"
        } else {
            iconName = "icon_category_\(baseName)_\(IconState.onWhite.rawValue)"
        }
        return SpendingCategoryData(id: id, isCustom: false, name: displayName, icon: CategoryIconName(rawValue: iconName)!)
    }

    static func fromIcon(_ icon: CategoryIconName) -> SpendingCategoryIconList? {
        switch icon {
        case .foodOnMint:
            return .food
        case .trafficOnMint:
            return .transportation
        case .beautyOnMint:
            return .beautyOrFashion
        case .marketOnMint:
            return .convenienceStore
        case .educationOnMint:
            return .education
        case .lifeOnMint:
            return .living
        case .healthOnMint:
            return .health
        case .hobbyOnMint:
            return .hobby
        case .travelOnMint:
            return .travel
        case .drinkOnMint:
            return .alcoholOrEntertainment
        case .eventOnMint:
            return .membershipOrFamilyEvent
        case .etcOnMint:
            return .other
        case .plusOff:
            return .plus
        default:
            return nil
        }
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
            return "icon_category_plus_off"
        }
    }
}
