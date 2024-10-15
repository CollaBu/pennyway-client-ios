//
//  ChatRouter.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Alamofire
import Foundation

enum ChatRouter: URLRequestConvertible {
    case getChatServer

    var method: HTTPMethod {
        switch self {
        case .getChatServer:
            return .get
        }
    }

    var baseURL: URL {
        switch self {
        case .getChatServer:
            return URL(string: API.BASE_URL)!
        }
    }

    var path: String {
        switch self {
        case .getChatServer:
            return "v2/socket/chat"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getChatServer:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case let .getChatServer:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .getChatServer:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
