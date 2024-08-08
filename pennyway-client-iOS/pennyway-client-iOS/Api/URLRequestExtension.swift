
import Alamofire
import Foundation
import OSLog

extension URLRequest {
    static func createURLRequest(url: URL, method: HTTPMethod, bodyParameters: [String: Any]? = nil, queryParameters: [URLQueryItem]? = nil, image: UIImage? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let image = image {
            if let imageData = image.jpegData(compressionQuality: 1.0) { // 압축정도 임시로 지정
                request.httpBody = imageData
                request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            }
        } else if let bodyParameters = bodyParameters {
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
            components?.percentEncodedQueryItems = queryParameters

            if let urlWithQuery = components?.url {
                request.url = urlWithQuery
            }
        }

        return request
    }
}
