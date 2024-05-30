
import Alamofire
import Foundation

enum TargetAmountRouter: URLRequestConvertible {
    case getTotalTargetAmount
 
    var method: HTTPMethod {
        switch self {
        case .getTotalTargetAmount:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getTotalTargetAmount:
            return "v2/targets/\(Date.getBasicformattedDate(from: Date()))"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getTotalTargetAmount:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .getTotalTargetAmount:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getTotalTargetAmount:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
