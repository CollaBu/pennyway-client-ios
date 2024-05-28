
import Alamofire
import Foundation
import OSLog

// MARK: - TokenHandler

protocol TokenHandler {
    func extractAndStoreToken(from response: AFDataResponse<Data?>)
}

extension TokenHandler {
    func extractAndStoreToken(from response: AFDataResponse<Data?>) {
        if let responseHeaders = response.response?.allHeaderFields as? [String: String],
           let accessToken = responseHeaders["Authorization"]
        {
            if response.value != nil {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: responseHeaders, for: response.response!.url!)
                for cookie in cookies {
                    Log.debug("Cookie name: \(cookie.name), value: \(cookie.value)")
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
            Log.debug("accessToken: \(accessToken)")
        }
    }
}
