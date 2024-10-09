
import Alamofire
import Foundation

enum ObjectStorageRouter: URLRequestConvertible {
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
            let queryDatas: [URLQueryItem] =
                [
                    URLQueryItem(name: "X-Amz-Algorithm", value: dto.algorithm),
                    URLQueryItem(name: "X-Amz-Date", value: dto.date),
                    URLQueryItem(name: "X-Amz-SignedHeaders", value: dto.signedHeaders),
                    URLQueryItem(name: "X-Amz-Credential", value: dto.credential),
                    URLQueryItem(name: "X-Amz-Expires", value: dto.expires),
                    URLQueryItem(name: "X-Amz-Signature", value: dto.signature)
                ]
            
            request = URLRequest.createURLRequest(url: baseURL, method: method, queryParameters: queryDatas, image: image, percentEncoded: true)
        }
        return request
    }
}
