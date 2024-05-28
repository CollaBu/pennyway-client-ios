
import Foundation

// MARK: - CategoryIconListItem

struct CategoryIconListItem: Identifiable {
    let id = UUID()
    let offIcon: String
    let onIcon: String
}

//// MARK: - SpendingCategoryIconList
//
//enum SpendingCategoryIconList: String {
//    case other = "OTHER"
//    case food = "FOOD"
//    case transportation = "TRANSPORTATION"
//    case beautyOrFashion = "BEAUTY_OR_FASHION"
//    case convenienceStore = "CONVENIENCE_STORE"
//    case education = "EDUCATION"
//    case living = "LIVING"
//    case health = "HEALTH"
//    case hobby = "HOBBY"
//    case travel = "TRAVEL"
//    case alcoholOrEntertainment = "ALCOHOL_OR_ENTERTAINMENT"
//    case membershipOrFamilyEvent = "MEMBERSHIP_OR_FAMILY_EVENT"
//}

struct SpendingCategoryData: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let category: SpendingCategoryIconList
}

enum SpendingCategoryIconList: String, CaseIterable {
    case other = "OTHER"
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

    var details: SpendingCategoryData {
        switch self {
        case .food:
            return SpendingCategoryData(icon: "icon_category_food_on", name: "식비", category: self)
        case .transportation:
            return SpendingCategoryData(icon: "icon_category_traffic_on", name: "교통", category: self)
        case .beautyOrFashion:
            return SpendingCategoryData(icon: "icon_category_beauty_on", name: "미용/패션", category: self)
        case .convenienceStore:
            return SpendingCategoryData(icon: "icon_category_market_on", name: "편의점/마트", category: self)
        case .education:
            return SpendingCategoryData(icon: "icon_category_education_on", name: "교육", category: self)
        case .living:
            return SpendingCategoryData(icon: "icon_category_life_on", name: "생활", category: self)
        case .health:
            return SpendingCategoryData(icon: "icon_category_health_on", name: "건강", category: self)
        case .hobby:
            return SpendingCategoryData(icon: "icon_category_hobby_on", name: "취미/여가", category: self)
        case .travel:
            return SpendingCategoryData(icon: "icon_category_travel_on", name: "여행/숙박", category: self)
        case .alcoholOrEntertainment:
            return SpendingCategoryData(icon: "icon_category_drink_on", name: "술/유흥", category: self)
        case .membershipOrFamilyEvent:
            return SpendingCategoryData(icon: "icon_category_event_on", name: "회비/경조사", category: self)
        case .other:
            return SpendingCategoryData(icon: "icon_category_plus_off", name: "추가하기", category: self)
        }
    }
}
