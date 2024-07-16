
import Alamofire
import Foundation

enum SpendingCategoryRouter: URLRequestConvertible {
    case addSpendingCustomCategory(dto: AddSpendingCustomCategoryRequestDto)
    case getSpendingCustomCategoryList
    case getCategorySpendingCount(categoryId: Int, dto: GetCategorySpendingCountRequestDto)
    case getCategorySpendingHistory(categoryId: Int, dto: GetCategorySpendingHistoryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingCustomCategoryList, .getCategorySpendingCount, .getCategorySpendingHistory:
            return .get
        case .addSpendingCustomCategory:
            return .post
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
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getSpendingCustomCategoryList, .addSpendingCustomCategory, .getCategorySpendingCount, .getCategorySpendingHistory:
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
        case .getSpendingCustomCategoryList:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .addSpendingCustomCategory, .getCategorySpendingCount, .getCategorySpendingHistory:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getSpendingCustomCategoryList:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}