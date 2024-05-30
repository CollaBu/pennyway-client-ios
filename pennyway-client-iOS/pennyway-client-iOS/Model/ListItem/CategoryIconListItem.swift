
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
    case trafficOff = "icon_category_traffic_off"
    case trafficOn = "icon_category_traffic_on"
    case beautyOff = "icon_category_beauty_off"
    case beautyOn = "icon_category_beauty_on"
    case marketOff = "icon_category_market_off"
    case marketOn = "icon_category_market_on"
    case educationOff = "icon_category_education_off"
    case educationOn = "icon_category_education_on"
    case lifeOff = "icon_category_life_off"
    case lifeOn = "icon_category_life_on"
    case healthOff = "icon_category_health_off"
    case healthOn = "icon_category_health_on"
    case hobbyOff = "icon_category_hobby_off"
    case hobbyOn = "icon_category_hobby_on"
    case travelOff = "icon_category_travel_off"
    case travelOn = "icon_category_travel_on"
    case drinkOff = "icon_category_drink_off"
    case drinkOn = "icon_category_drink_on"
    case eventOff = "icon_category_event_off"
    case eventOn = "icon_category_event_on"
    case etcOff = "icon_category_etc_off"
    case etcOn = "icon_category_etc_on"
    case otherOff = "icon_category_plus_off"
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
            return SpendingCategoryData(id: -12, isCustom: false, name: "추가하기", icon: .otherOff)
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
            return .other // TODO: 추후 수정 필요
        default:
            return nil
        }
    }
}
