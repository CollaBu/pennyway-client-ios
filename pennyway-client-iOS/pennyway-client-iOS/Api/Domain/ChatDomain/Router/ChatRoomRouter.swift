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
    case getPreviousChat(chatRoomId: Int64, dto: GetPreviousChatRequestDto)

    var method: HTTPMethod {
        switch self {
        case .getChatRoomDetail, .getPreviousChat:
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
        case let .getPreviousChat(chatRoomId, _):
            return "v2/chat-rooms/\(chatRoomId)/chats"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getChatRoomDetail, .getPreviousChat:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .getChatRoomDetail:
            return [:]
        case let .getPreviousChat(_, dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .getChatRoomDetail:
            request = URLRequest.createURLRequest(url: url, method: method)
        case .getPreviousChat:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
