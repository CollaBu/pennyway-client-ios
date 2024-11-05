//
//  ChatRouter.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 아우신얀 on 10/15/24.
//

import Alamofire
import Foundation

enum ChatRouter: URLRequestConvertible {
    case getChatServer
    case makeChatRoom(dto: MakeChatRoomRequestDto)
    case searchChatRoom(dto: SearchChatRoomRequestDto)
    case getChatRoom

    var method: HTTPMethod {
        switch self {
        case .getChatServer, .getChatRoom, .searchChatRoom:
            return .get
        case .makeChatRoom:
            return .post
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case .makeChatRoom, .searchChatRoom:
            return "v2/chat-rooms"
        case .getChatServer:
            return "v2/socket/chat"
        case .getChatRoom:
            return "v2/chat-rooms/me"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case let .makeChatRoom(dto):
            return try? dto.asDictionary()
        case .getChatServer, .getChatRoom, .searchChatRoom:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .getChatServer, .makeChatRoom, .getChatRoom:
            return [:]
        case let .searchChatRoom(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .makeChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        case .searchChatRoom:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getChatServer, .getChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
