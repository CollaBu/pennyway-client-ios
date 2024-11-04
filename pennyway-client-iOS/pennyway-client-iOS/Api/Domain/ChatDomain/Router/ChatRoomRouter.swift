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

    var method: HTTPMethod {
        switch self {
        case .getChatRoomDetail:
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
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getChatRoomDetail:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .getChatRoomDetail:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .getChatRoomDetail:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
