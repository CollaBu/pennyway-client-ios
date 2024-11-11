//
//  ChatRoomRouter.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Alamofire
import Foundation

enum ChatRoomRouter: URLRequestConvertible {
    case getChatRoomDetail(chatRoomId: Int64)
    case getChatData(chatRoomId: Int64, lastMessageId: Int64)

    var method: HTTPMethod {
        switch self {
        case .getChatRoomDetail, .getChatData:
            return .get
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case let .getChatRoomDetail(chatRoomId):
            return "v2/chat-rooms/\(chatRoomId)"
        case let .getChatData(chatRoomId, _):
            return "v2/chat-rooms/\(chatRoomId)/chats"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getChatRoomDetail, .getChatData:
            return [:]
            
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .getChatRoomDetail:
            return [:]
        case let .getChatData(_, lastMessageId):
            return ["lastMessageId": lastMessageId]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .getChatRoomDetail:
            request = URLRequest.createURLRequest(url: url, method: method)
        case .getChatData:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
