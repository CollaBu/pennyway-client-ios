
import Alamofire
import Foundation

enum TargetAmountRouter: URLRequestConvertible {
    case getTotalTargetAmount(dto: GetTotalTargetAmountRequestDto)
    case generateCurrentMonthDummyData(dto: GenerateCurrentMonthDummyDataRequestDto)
    case getTargetAmountForDate, deleteCurrentMonthTargetAmount, getTargetAmountForPreviousMonth
    case editCurrentMonthTargetAmount(dto: EditCurrentMonthTargetAmountRequestDto)
 
    var method: HTTPMethod {
        switch self {
        case .getTargetAmountForDate, .getTotalTargetAmount, .getTargetAmountForPreviousMonth:
            return .get
        case .generateCurrentMonthDummyData:
            return .post
        case .deleteCurrentMonthTargetAmount:
            return .delete
        case .editCurrentMonthTargetAmount:
            return .patch
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getTotalTargetAmount, .generateCurrentMonthDummyData:
            return "v2/target-amounts"
        case .getTargetAmountForDate:
            return "v2/target-amounts/\(Date.getBasicformattedDate(from: Date()))"
        case .deleteCurrentMonthTargetAmount, .editCurrentMonthTargetAmount:
            return "v2/target-amounts/id값"
        case .getTargetAmountForPreviousMonth:
            return "v2/target-amounts/recent"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getTargetAmountForDate, .getTotalTargetAmount, .generateCurrentMonthDummyData, .deleteCurrentMonthTargetAmount, .editCurrentMonthTargetAmount, .getTargetAmountForPreviousMonth:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .getTotalTargetAmount(dto):
            return try? dto.asDictionary()
        case let .generateCurrentMonthDummyData(dto):
            return try? dto.asDictionary()
        case let .editCurrentMonthTargetAmount(dto):
            return try? dto.asDictionary()
        case .getTargetAmountForDate, .deleteCurrentMonthTargetAmount, .getTargetAmountForPreviousMonth:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getTotalTargetAmount, .generateCurrentMonthDummyData, .editCurrentMonthTargetAmount:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getTargetAmountForDate, .deleteCurrentMonthTargetAmount, .getTargetAmountForPreviousMonth:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
