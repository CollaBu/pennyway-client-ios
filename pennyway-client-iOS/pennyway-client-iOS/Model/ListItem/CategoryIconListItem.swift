
import Foundation

// MARK: - CategoryIconListItem

struct CategoryIconListItem: Identifiable {
    let id = UUID()
    let offIcon: String
    let onIcon: String
}

// MARK: - SpendingCategoryIconList

enum SpendingCategoryIconList: String {
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
}
