
import Alamofire
import Foundation

enum SpendingRouter: URLRequestConvertible {
    case getSpendingHistory(dto: GetSpendingHistoryRequestDto)
    case addSpendingHistory(dto: AddSpendingHistoryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingHistory:
            return .get
        case .addSpendingHistory:
            return .post
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getSpendingHistory, .addSpendingHistory:
            return "v2/spendings"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getSpendingHistory:
            return [:]
        case let .addSpendingHistory(dto):
            return try? dto.asDictionary()
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .getSpendingHistory(dto):
            return try? dto.asDictionary()
        case .addSpendingHistory:
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
        case .addSpendingHistory:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        }
        return request
    }
}
