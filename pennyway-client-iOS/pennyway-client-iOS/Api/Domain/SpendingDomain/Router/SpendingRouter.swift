
import Alamofire
import Foundation

enum SpendingRouter: URLRequestConvertible {
    case getSpendingHistory(dto: GetSpendingHistoryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingHistory:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getSpendingHistory:
            return "v2/spendings"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getSpendingHistory:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case let .getSpendingHistory(dto):
            let queryParameters = [URLQueryItem(name: "year", value: dto.year), URLQueryItem(name: "month", value: dto.month)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
        }
        return request
    }
}
