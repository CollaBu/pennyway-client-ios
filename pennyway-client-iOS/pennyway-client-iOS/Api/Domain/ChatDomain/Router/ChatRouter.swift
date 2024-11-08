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
    case searchChatRoom(dto: SearchChatRoomRequestDto)
    case getChatRoom
    case joinChatRoom(chatRoomId: Int64, dto: JoinChatRoomRequestDto)

    var method: HTTPMethod {
        switch self {
        case .getChatServer, .getChatRoom, .getJoinedChatRooms, .searchChatRoom:
            return .get
        case .makeChatRoom, .joinChatRoom:
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
        case .getJoinedChatRooms:
            return "v2/chat-rooms/me"
        case .getChatRoom:
            return "v2/chat-rooms/me"
        case let .joinChatRoom(chatRoomId, _):
            return "v2/chat-rooms/\(chatRoomId)/chat-members"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case let .makeChatRoom(dto):
            return try? dto.asDictionary()
        case let .joinChatRoom(_, dto):
            return try? dto.asDictionary()
        case .getChatServer, .getChatRoom, .searchChatRoom, .getJoinedChatRooms:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case let .getJoinedChatRooms(dto):
            return try? dto.asDictionary()

        case .getChatServer, .makeChatRoom, .getChatRoom, .joinChatRoom:
            return [:]

        case let .searchChatRoom(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .makeChatRoom, .joinChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        case .searchChatRoom:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getChatServer, .getChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method)
        case .getJoinedChatRooms:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
