//
//  AdminRouter.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 3/28/24.
//

import Foundation
import Alamofire

enum AdminRouter: URLRequestConvertible {

    case regist(username: String, name: String, password: String)
    
    var method: HTTPMethod {
        switch self {
        case .regist:
            return .post
        }
    }
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .regist:
            return "v1/auth/register"
      
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .regist(username, name, password):
            return ["username": username, "name": name, "password": password]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        return request
    }
}
