
import Alamofire
import Foundation

enum TargetAmountRouter: URLRequestConvertible {
    case getTotalTargetAmount(dto: GetTotalTargetAmountRequestDto)
 
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
            return "v2/targets"
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
        case let .getTotalTargetAmount(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getTotalTargetAmount:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
