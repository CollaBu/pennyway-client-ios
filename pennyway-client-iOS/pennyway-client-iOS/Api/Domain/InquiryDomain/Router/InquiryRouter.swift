
import Alamofire
import Foundation

enum InquiryRouter: URLRequestConvertible {
    case sendInquiryMail(dto: InquiryRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .sendInquiryMail:
            return .post
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .sendInquiryMail:
            return "v1/questions"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .sendInquiryMail(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .sendInquiryMail:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        }
        return request
    }
}
