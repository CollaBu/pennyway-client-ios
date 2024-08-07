
import Alamofire
import Foundation

enum StorageRouter: URLRequestConvertible {
    case generatePresignedUrl(dto: GeneratePresigendUrlRequeatDto)
    
    var method: HTTPMethod {
        switch self {
        case .generatePresignedUrl:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .generatePresignedUrl:
            return "v1/storage/presigned_url"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .generatePresignedUrl:
            return [:]
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case let .generatePresignedUrl(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .generatePresignedUrl:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
