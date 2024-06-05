
import Alamofire
import Foundation

enum TargetAmountRouter: URLRequestConvertible {
    case getTotalTargetAmount(dto: GetTotalTargetAmountRequestDto)
    case getTargetAmountForDate
 
    var method: HTTPMethod {
        switch self {
        case .getTargetAmountForDate, .getTotalTargetAmount:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
            
        case .getTotalTargetAmount:
            return "v2/targets-amounts"
        case .getTargetAmountForDate:
            return "v2/targets-amounts/\(Date.getBasicformattedDate(from: Date()))"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getTargetAmountForDate, .getTotalTargetAmount:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .getTotalTargetAmount(dto):
            return try? dto.asDictionary()
        case .getTargetAmountForDate:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getTotalTargetAmount:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getTargetAmountForDate:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
