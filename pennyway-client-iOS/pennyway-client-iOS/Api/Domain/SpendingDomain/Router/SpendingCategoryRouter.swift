
import Alamofire
import Foundation

enum SpendingCategoryRouter: URLRequestConvertible {
    case addSpendingCustomCategory(dto: AddSpendingCustomCategoryRequestDto)
    case getSpendingCustomCategoryList
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingCustomCategoryList:
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
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getSpendingCustomCategoryList, .addSpendingCustomCategory:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .addSpendingCustomCategory(dto):
            return try? dto.asDictionary()
        case .getSpendingCustomCategoryList:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .addSpendingCustomCategory:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getSpendingCustomCategoryList:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
