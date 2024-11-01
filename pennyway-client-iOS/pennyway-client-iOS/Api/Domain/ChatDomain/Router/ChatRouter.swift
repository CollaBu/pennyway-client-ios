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
    case getJoinedChatRooms(dto: GetJoinedChatRoomsRequestDto)
    case makeChatRoom(dto: MakeChatRoomRequestDto)
    case getChatRoom

    var method: HTTPMethod {
        switch self {
        case .getChatServer, .getChatRoom, .getJoinedChatRooms:
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
        case .makeChatRoom:
            return "v2/chat-rooms"
        case .getChatServer:
            return "v2/socket/chat"
        case .getJoinedChatRooms:
            return "v2/chat-rooms"
        case .getChatRoom:
            return "v2/chat-rooms/me"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case let .makeChatRoom(dto):
            return try? dto.asDictionary()
        case .getChatServer, .getChatRoom, .getJoinedChatRooms:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case let .getJoinedChatRooms(dto):
            return try? dto.asDictionary()

        case .getChatServer, .makeChatRoom, .getChatRoom:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .makeChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        case .getChatServer, .getChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method)
        case .getJoinedChatRooms:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
