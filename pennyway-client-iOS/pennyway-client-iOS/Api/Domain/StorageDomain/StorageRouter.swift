
import Alamofire
import Foundation

enum StorageRouter: URLRequestConvertible {
    case generatePresignedUrl(dto: GeneratePresigendUrlRequestDto)
    case storePresignedUrl(payload: String, dto: StorePresignedUrlRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .generatePresignedUrl:
            return .get
        case .storePresignedUrl:
            return .put
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .generatePresignedUrl:
            return "v1/storage/presigned-url"
        case let .storePresignedUrl(payload, _):
            return "\(payload)"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .generatePresignedUrl, .storePresignedUrl:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .generatePresignedUrl(dto):
            return try? dto.asDictionary()
        case let .storePresignedUrl(_, dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .generatePresignedUrl, .storePresignedUrl:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
