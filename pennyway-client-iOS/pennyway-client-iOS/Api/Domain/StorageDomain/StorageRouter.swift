
import Alamofire
import Foundation

enum StorageRouter: URLRequestConvertible {
    case generatePresignedUrl(dto: GeneratePresigendUrlRequestDto)
    case storePresignedUrl(payload: String, image: UIImage, dto: StorePresignedUrlRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .generatePresignedUrl:
            return .get
        case .storePresignedUrl:
            return .put
        }
    }
    
    var baseURL: URL {
        switch self {
        case .generatePresignedUrl:
            return URL(string: API.BASE_URL)!
        case let .storePresignedUrl(payload, _, _):
            return URL(string: payload) ?? URL(string: "")!
        }
    }
    
    var path: String {
        switch self {
        case .generatePresignedUrl:
            return "v1/storage/presigned-url"
        case .storePresignedUrl:
            return ""
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
        case .storePresignedUrl:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .generatePresignedUrl:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
            
        case let .storePresignedUrl(_, image, dto):
            request = URLRequest.createURLRequest(url: baseURL, method: method, queryParameters: dto.toQueryItems(), image: image)
        }
        return request
    }
}
