
import Alamofire
import Foundation

enum SpendingCategoryRouter: URLRequestConvertible {
    case addSpendingCustomCategory(dto: AddSpendingCustomCategoryRequestDto)
    case getSpendingCustomCategoryList
    case getCategorySpendingCount(categoryId: Int, dto: GetCategorySpendingCountRequestDto)
    case getCategorySpendingHistory(categoryId: Int, dto: GetCategorySpendingHistoryRequestDto)
    case modifyCategory(categoryId: Int, dto: AddSpendingCustomCategoryRequestDto)
    case deleteCategory(categoryId: Int)
    case moveCategory(fromId: Int, dto: MoveCategoryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingCustomCategoryList, .getCategorySpendingCount, .getCategorySpendingHistory:
            return .get
        case .addSpendingCustomCategory:
            return .post
        case .modifyCategory, .moveCategory:
            return .patch
        case .deleteCategory:
            return .delete
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getSpendingCustomCategoryList, .addSpendingCustomCategory:
            return "v2/spending-categories"
        case let .getCategorySpendingHistory(categoryId, _):
            return "v2/spending-categories/\(categoryId)/spendings"
        case let .getCategorySpendingCount(categoryId, _):
            return "v2/spending-categories/\(categoryId)/spendings/count"
        case let .modifyCategory(categoryId, _):
            return "v2/spending-categories/\(categoryId)"
        case let .deleteCategory(categoryId):
            return "v2/spending-categories/\(categoryId)"
        case let .moveCategory(fromId, _):
            return "v2/spending-categories/\(fromId)/migration"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getSpendingCustomCategoryList, .addSpendingCustomCategory, .getCategorySpendingCount, .getCategorySpendingHistory, .modifyCategory, .deleteCategory, .moveCategory:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .addSpendingCustomCategory(dto):
            return try? dto.asDictionary()
        case let .getCategorySpendingCount(_, dto):
            return try? dto.asDictionary()
        case let .getCategorySpendingHistory(_, dto):
            return try? dto.asDictionary()
        case let .modifyCategory(_, dto):
            return try? dto.asDictionary()
        case let .moveCategory(_, dto):
            return try? dto.asDictionary()
        case .getSpendingCustomCategoryList, .deleteCategory:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .addSpendingCustomCategory, .getCategorySpendingCount, .getCategorySpendingHistory, .modifyCategory, .moveCategory:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getSpendingCustomCategoryList, .deleteCategory:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
