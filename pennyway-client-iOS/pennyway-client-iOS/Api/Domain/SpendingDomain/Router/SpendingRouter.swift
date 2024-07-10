
import Alamofire
import Foundation

enum SpendingRouter: URLRequestConvertible {
    case getSpendingHistory(dto: GetSpendingHistoryRequestDto)
    case addSpendingHistory(dto: AddSpendingHistoryRequestDto)
    case deleteSpendingHistory(spendingId: Int)
    case getDetailSpendingHistory(spendingId: Int)
    case editSpendingHistory(Spending: Int, dto: AddSpendingHistoryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingHistory, .getDetailSpendingHistory:
            return .get
        case .addSpendingHistory, .editSpendingHistory:
            return .post
        case .deleteSpendingHistory:
            return .delete
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getSpendingHistory, .addSpendingHistory:
            return "v2/spendings"
        case let .deleteSpendingHistory(spendingId), let .getDetailSpendingHistory(spendingId), let .editSpendingHistory(spendingId, _):
            return "v2/spendings/\(spendingId)"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getSpendingHistory, .deleteSpendingHistory, .getDetailSpendingHistory:
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
        case .addSpendingHistory, .deleteSpendingHistory, .getDetailSpendingHistory, .editSpendingHistory:
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
        case .addSpendingHistory, .editSpendingHistory: // .?
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        case .deleteSpendingHistory, .getDetailSpendingHistory:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
