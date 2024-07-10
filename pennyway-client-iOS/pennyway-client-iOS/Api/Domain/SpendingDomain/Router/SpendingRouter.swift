
import Alamofire
import Foundation

enum SpendingRouter: URLRequestConvertible {
    case getSpendingHistory(dto: GetSpendingHistoryRequestDto)
    case addSpendingHistory(dto: AddSpendingHistoryRequestDto)
    case addSpendingCustomCategory(dto: AddSpendingCustomCategoryRequestDto)
    case getSpendingCustomCategoryList
    case deleteSpendingHistory(spendingId: Int)
    case getDetailSpendingHistory(spendingId: Int)
    case editSpendingHistory(spendingId: Int, dto: AddSpendingHistoryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingHistory, .getSpendingCustomCategoryList, .getDetailSpendingHistory:
            return .get
        case .addSpendingCustomCategory, .addSpendingHistory:
            return .post
        case .deleteSpendingHistory:
            return .delete
        case .editSpendingHistory:
            return .put
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getSpendingHistory, .addSpendingHistory:
            return "v2/spendings"
        case .getSpendingCustomCategoryList, .addSpendingCustomCategory:
            return "v2/spending-categories"
        case let .deleteSpendingHistory(spendingId), let .getDetailSpendingHistory(spendingId), let .editSpendingHistory(spendingId, _):
            return "v2/spendings/\(spendingId)"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getSpendingHistory, .getSpendingCustomCategoryList, .addSpendingCustomCategory, .deleteSpendingHistory, .getDetailSpendingHistory:
            return [:]
        case let .addSpendingHistory(dto):
            return try? dto.asDictionary()
        case let .editSpendingHistory(_, dto):
            return try? dto.asDictionary()
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .getSpendingHistory(dto):
            return try? dto.asDictionary()
        case let .addSpendingCustomCategory(dto):
            return try? dto.asDictionary()
        
        case .getSpendingCustomCategoryList, .addSpendingHistory, .deleteSpendingHistory, .getDetailSpendingHistory, .editSpendingHistory:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getSpendingHistory:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .addSpendingHistory, .editSpendingHistory: 
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        case .addSpendingCustomCategory:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getSpendingCustomCategoryList, .deleteSpendingHistory, .getDetailSpendingHistory:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
