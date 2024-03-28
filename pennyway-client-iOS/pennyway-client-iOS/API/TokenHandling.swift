import Foundation
import Alamofire
import OSLog

protocol TokenHandling {
    func extractAndStoreToken(from response: AFDataResponse<Data?>)
}

extension TokenHandling {
    func extractAndStoreToken(from response: AFDataResponse<Data?>) {
        
        if let responseHeaders = response.response?.allHeaderFields as? [String: String],
           let accessToken = responseHeaders["Authorization"] {
            
            if response.value != nil {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: responseHeaders, for: response.response!.url!)
                for cookie in cookies {
                    print("Cookie name: \(cookie.name), value: \(cookie.value)")
                    
                    let nsCookie = HTTPCookie(properties: [
                        HTTPCookiePropertyKey.name: cookie.name,
                        HTTPCookiePropertyKey.value: cookie.value,
                        HTTPCookiePropertyKey.domain: cookie.domain,
                        HTTPCookiePropertyKey.path: cookie.path,
                        HTTPCookiePropertyKey.version: NSNumber(value: cookie.version),
                        HTTPCookiePropertyKey.expires: cookie.expiresDate ?? Date.distantFuture
                    ])
                    
                    HTTPCookieStorage.shared.setCookie(nsCookie!)
                }
            }
            
            KeychainHelper.saveAccessToken(accessToken: accessToken)
            os_log("accessToken: %@", log: .default, type: .info, accessToken)
        }
    }
}
