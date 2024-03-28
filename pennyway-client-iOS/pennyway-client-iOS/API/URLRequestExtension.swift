//
//  URLRequestExtension.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 3/28/24.
//

import Foundation
import OSLog
import Alamofire

extension URLRequest {
    static func createURLRequest(url: URL, method: HTTPMethod, bodyParameters: [String: Any]? = nil, queryParameters: [URLQueryItem]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let bodyParameters = bodyParameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
                os_log("JSON encoding failed. Error: %@", log: log, type: .error, "\(error)")
            }
        }

        if let queryParameters = queryParameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryParameters

            if let urlWithQuery = components?.url {
                request.url = urlWithQuery
            }
        }

        return request
    }
}
