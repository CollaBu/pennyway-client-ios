
import Alamofire
import Foundation

enum SpendingRouter: URLRequestConvertible {
    case getSpendingHistory(dto: GetSpendingHistoryRequestDto)
    case addSpendingHistory(dto: AddSpendingHistoryRequestDto)
    case deleteSpendingHistory(dto: DeleteSpendingHistoryRequestDto) // 지출내역 복수 삭제
    case getDetailSpendingHistory(spendingId: Int)
    case editSpendingHistory(Spending: Int, dto: AddSpendingHistoryRequestDto)
    case deleteSingleSpendingHistory(spendingId: Int) // 지출내역 단일 삭제
    
    var method: HTTPMethod {
        switch self {
        case .getSpendingHistory, .getDetailSpendingHistory:
            return .get
        case .addSpendingHistory, .editSpendingHistory:
            return .post
        case .deleteSpendingHistory, .deleteSingleSpendingHistory:
            return .delete
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getSpendingHistory, .addSpendingHistory, .deleteSpendingHistory:
            return "v2/spendings"

        case let .getDetailSpendingHistory(spendingId), let .editSpendingHistory(spendingId, _), let .deleteSingleSpendingHistory(spendingId):
            return "v2/spendings/\(spendingId)"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getSpendingHistory, .getDetailSpendingHistory, .deleteSingleSpendingHistory:
            return [:]
        case let .addSpendingHistory(dto):
            return try? dto.asDictionary()
        case let .editSpendingHistory(_, dto):
            return try? dto.asDictionary()
        case let .deleteSpendingHistory(dto):
            return try? dto.asDictionary()
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .getSpendingHistory(dto):
            return try? dto.asDictionary()
        case .addSpendingHistory, .deleteSpendingHistory, .getDetailSpendingHistory, .editSpendingHistory, .deleteSingleSpendingHistory:
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
        case .addSpendingHistory, .editSpendingHistory, .deleteSpendingHistory:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        case .getDetailSpendingHistory, .deleteSingleSpendingHistory:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
