
import Alamofire
import Foundation

// MARK: - TokenHandler

class TokenHandler {
    static func extractAndStoreToken(from response: AFDataResponse<Data?>) {
        if let responseHeaders = response.response?.allHeaderFields as? [String: String],
           let accessToken = responseHeaders["Authorization"]
        {
            if response.value != nil {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: responseHeaders, for: response.response!.url!)
                for cookie in cookies {
                    Log.info("Cookie name: \(cookie.name), value: \(cookie.value)")
                    let nsCookie = HTTPCookie(properties: [
                        HTTPCookiePropertyKey.name: cookie.name,
                        HTTPCookiePropertyKey.value: cookie.value,
                        HTTPCookiePropertyKey.domain: cookie.domain,
                        HTTPCookiePropertyKey.path: cookie.path,
                        HTTPCookiePropertyKey.version: NSNumber(value: cookie.version),
                        HTTPCookiePropertyKey.expires: cookie.expiresDate ?? Date.distantFuture,
                    ])

                    if let nsCookie = nsCookie {
                        HTTPCookieStorage.shared.setCookie(nsCookie)
                    }
                }
            }
            KeychainHelper.saveAccessToken(accessToken: accessToken)
            Log.info("accessToken: \(accessToken)")
        }
    }

    static func deleteAllRefreshTokens() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies where cookie.name == "refreshToken" {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
}

// MARK: - JWTError

enum JWTError: Error {
    case encodingFailed
    case invalidSecret
}

import CryptoKit
import Foundation

// MARK: - AccessTokenGenerator

class AccessTokenGenerator {
    private let secretKey: Data
    private let expirationTimeMs: Int64

    enum JWTError: Error {
        case encodingFailed
        case invalidSecretKey
    }

    init(secretKey: String, expirationTimeMs: Int64) {
        // 평문 시크릿 키를 Base64로 인코딩한 후 다시 디코딩
        let secretKeyBase64 = secretKey.data(using: .utf8)!.base64EncodedString()
        self.secretKey = Data(base64Encoded: secretKeyBase64)!
        self.expirationTimeMs = expirationTimeMs
    }

    private func createHeader() -> [String: Any] {
        return [
            "typ": "JWT",
            "alg": "HS256",
            "regDate": Int64(Date().timeIntervalSince1970 * 1000)
        ]
    }

    func generateToken(userId: Int64, role: String) throws -> String {
        let now = Date()
        let expireDate = now.addingTimeInterval(TimeInterval(expirationTimeMs) / 1000.0)

        // Claims 생성
        let claims: [String: Any] = [
            "userId": String(userId), // 서버와 동일하게 문자열로 변환
            "role": role,
            "exp": Int64(expireDate.timeIntervalSince1970)
        ]

        // Header를 Base64URL로 인코딩
        let header = createHeader()
        guard let headerData = try? JSONSerialization.data(withJSONObject: header) else {
            throw JWTError.encodingFailed
        }
        let headerBase64 = headerData.base64UrlEncodedString()

        // Payload를 Base64URL로 인코딩
        guard let payloadData = try? JSONSerialization.data(withJSONObject: claims) else {
            throw JWTError.encodingFailed
        }
        let payloadBase64 = payloadData.base64UrlEncodedString()

        // Signature 생성
        let signingInput = "\(headerBase64).\(payloadBase64)".data(using: .utf8)!
        let signature = HMAC<SHA256>.authenticationCode(
            for: signingInput,
            using: SymmetricKey(data: secretKey)
        )
        let signatureBase64 = Data(signature).base64UrlEncodedString()

        // 최종 토큰 생성
        return "\(headerBase64).\(payloadBase64).\(signatureBase64)"
    }
}

/// Base64URL 인코딩을 위한 확장
extension Data {
    func base64UrlEncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
