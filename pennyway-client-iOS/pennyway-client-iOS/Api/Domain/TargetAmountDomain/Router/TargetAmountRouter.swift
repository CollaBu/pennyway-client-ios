
import Alamofire
import Foundation

enum TargetAmountRouter: URLRequestConvertible {
    case getTargetAmountForDate
 
    var method: HTTPMethod {
        switch self {
        case .getTargetAmountForDate:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getTargetAmountForDate:
            return "v2/targets-amounts/\(Date.getBasicformattedDate(from: Date()))"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getTargetAmountForDate:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .getTargetAmountForDate:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getTargetAmountForDate:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
