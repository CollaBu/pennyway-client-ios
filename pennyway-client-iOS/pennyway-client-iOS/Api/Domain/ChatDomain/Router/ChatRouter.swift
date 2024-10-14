
import Alamofire
import Foundation

enum ChatRouter: URLRequestConvertible {
    case makeChatRoom(dto: MakeChatRoomRequestDto)

    var method: HTTPMethod {
        switch self {
        case .makeChatRoom:
            return .post
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case .makeChatRoom:
            return "v2/chat-rooms"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case let .makeChatRoom(dto):
            return try? dto.asDictionary()
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .makeChatRoom:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {

        case .makeChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        }
        return request
    }
}

