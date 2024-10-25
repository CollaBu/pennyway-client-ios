
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

    var method: HTTPMethod {
        switch self {
        case .getChatServer:
            return .get
        case .makeChatRoom:
            return .post
        }
    }

    var baseURL: URL {
//        switch self {
//        case .getChatServer:
//            return URL(string: API.BASE_URL)!
//        }

        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case .makeChatRoom:
            return "v2/chat-rooms"
        case .getChatServer:
            return "v2/socket/chat"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case let .makeChatRoom(dto):
            return try? dto.asDictionary()
        case .getChatServer:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .getChatServer, .makeChatRoom:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .makeChatRoom:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: bodyParameters)
        case .getChatServer:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
