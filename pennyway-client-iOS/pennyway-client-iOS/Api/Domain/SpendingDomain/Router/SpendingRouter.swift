
import Alamofire
import Foundation

enum SpendingRouter: URLRequestConvertible {
    case checkSpendingHistory(dto: CheckSpendingHistoryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .checkSpendingHistory:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .checkSpendingHistory:
            return "v2/spendings"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .checkSpendingHistory:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case let .checkSpendingHistory(dto):
            let queryParameters = [URLQueryItem(name: "year", value: dto.year), URLQueryItem(name: "month", value: dto.month)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
  
        }
        return request
    }
}
