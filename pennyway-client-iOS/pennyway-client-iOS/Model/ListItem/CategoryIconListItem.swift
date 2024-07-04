
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
    case trafficOff = "icon_category_traffic_off"
    case trafficOn = "icon_category_traffic_on"
    case trafficOnWhite = "icon_category_traffic_on_white"
    case beautyOff = "icon_category_beauty_off"
    case beautyOn = "icon_category_beauty_on"
    case beautyOnWhite = "icon_category_beauty_on_white"
    case marketOff = "icon_category_market_off"
    case marketOn = "icon_category_market_on"
    case marketOnWhite = "icon_category_market_on_white"
    case educationOff = "icon_category_education_off"
    case educationOn = "icon_category_education_on"
    case educationOnWhite = "icon_category_education_on_white"
    case lifeOff = "icon_category_life_off"
    case lifeOn = "icon_category_life_on"
    case lifeOnWhite = "icon_category_life_on_white"
    case healthOff = "icon_category_health_off"
    case healthOn = "icon_category_health_on"
    case healthOnWhite = "icon_category_health_on_white"
    case hobbyOff = "icon_category_hobby_off"
    case hobbyOn = "icon_category_hobby_on"
    case hobbyOnWhite = "icon_category_hobby_on_white"
    case travelOff = "icon_category_travel_off"
    case travelOn = "icon_category_travel_on"
    case travelOnWhite = "icon_category_travel_on_white"
    case drinkOff = "icon_category_drink_off"
    case drinkOn = "icon_category_drink_on"
    case drinkOnWhite = "icon_category_drink_on_white"
    case eventOff = "icon_category_event_off"
    case eventOn = "icon_category_event_on"
    case eventOnWhite = "icon_category_event_on_white"
    case etcOff = "icon_category_etc_off"
    case etcOn = "icon_category_etc_on"
    case etcOnWhite = "icon_category_etc_on_white"
    case plusOff = "icon_category_plus_off"
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

    var details: SpendingCategoryData {
        switch self {
        case .food:
            return SpendingCategoryData(id: -1, isCustom: false, name: "식비", icon: .foodOn)
        case .transportation:
            return SpendingCategoryData(id: -2, isCustom: false, name: "교통", icon: .trafficOn)
        case .beautyOrFashion:
            return SpendingCategoryData(id: -3, isCustom: false, name: "미용/패션", icon: .beautyOn)
        case .convenienceStore:
            return SpendingCategoryData(id: -4, isCustom: false, name: "편의점/마트", icon: .marketOn)
        case .education:
            return SpendingCategoryData(id: -5, isCustom: false, name: "교육", icon: .educationOn)
        case .living:
            return SpendingCategoryData(id: -6, isCustom: false, name: "생활", icon: .lifeOn)
        case .health:
            return SpendingCategoryData(id: -7, isCustom: false, name: "건강", icon: .healthOn)
        case .hobby:
            return SpendingCategoryData(id: -8, isCustom: false, name: "취미/여가", icon: .hobbyOn)
        case .travel:
            return SpendingCategoryData(id: -9, isCustom: false, name: "여행/숙박", icon: .travelOn)
        case .alcoholOrEntertainment:
            return SpendingCategoryData(id: -10, isCustom: false, name: "술/유흥", icon: .drinkOn)
        case .membershipOrFamilyEvent:
            return SpendingCategoryData(id: -11, isCustom: false, name: "회비/경조사", icon: .eventOn)
        case .other:
            return SpendingCategoryData(id: -12, isCustom: false, name: "기타", icon: .etcOn)
        case .plus:
            return SpendingCategoryData(id: -13, isCustom: false, name: "추가하기", icon: .plusOff)
        }
    }
    
    var detailsWhite: SpendingCategoryData {
        switch self {
        case .food:
            return SpendingCategoryData(id: -1, isCustom: false, name: "식비", icon: .foodOnWhite)
        case .transportation:
            return SpendingCategoryData(id: -2, isCustom: false, name: "교통", icon: .trafficOnWhite)
        case .beautyOrFashion:
            return SpendingCategoryData(id: -3, isCustom: false, name: "미용/패션", icon: .beautyOnWhite)
        case .convenienceStore:
            return SpendingCategoryData(id: -4, isCustom: false, name: "편의점/마트", icon: .marketOnWhite)
        case .education:
            return SpendingCategoryData(id: -5, isCustom: false, name: "교육", icon: .educationOnWhite)
        case .living:
            return SpendingCategoryData(id: -6, isCustom: false, name: "생활", icon: .lifeOnWhite)
        case .health:
            return SpendingCategoryData(id: -7, isCustom: false, name: "건강", icon: .healthOnWhite)
        case .hobby:
            return SpendingCategoryData(id: -8, isCustom: false, name: "취미/여가", icon: .hobbyOnWhite)
        case .travel:
            return SpendingCategoryData(id: -9, isCustom: false, name: "여행/숙박", icon: .travelOnWhite)
        case .alcoholOrEntertainment:
            return SpendingCategoryData(id: -10, isCustom: false, name: "술/유흥", icon: .drinkOnWhite)
        case .membershipOrFamilyEvent:
            return SpendingCategoryData(id: -11, isCustom: false, name: "회비/경조사", icon: .eventOnWhite)
        case .other:
            return SpendingCategoryData(id: -12, isCustom: false, name: "기타", icon: .etcOnWhite)
        case .plus:
            return SpendingCategoryData(id: -13, isCustom: false, name: "", icon: .etcOnWhite)
        }
    }

    static func fromIcon(_ icon: CategoryIconName) -> SpendingCategoryIconList? {
        switch icon {
        case .foodOn:
            return .food
        case .trafficOn:
            return .transportation
        case .beautyOn:
            return .beautyOrFashion
        case .marketOn:
            return .convenienceStore
        case .educationOn:
            return .education
        case .lifeOn:
            return .living
        case .healthOn:
            return .health
        case .hobbyOn:
            return .hobby
        case .travelOn:
            return .travel
        case .drinkOn:
            return .alcoholOrEntertainment
        case .eventOn:
            return .membershipOrFamilyEvent
        case .etcOn:
            return .other
        case .plusOff:
            return .plus // TODO: 추후 수정 필요
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
