
import Foundation

// MARK: - StorePresignedUrlRequestDto

public struct StorePresignedUrlRequestDto: Encodable {
    let algorithm: String
    let date: String
    let signedHeaders: String
    let credential: String
    let expires: String
    let signature: String

    public init(
        algorithm: String,
        date: String,
        signedHeaders: String,
        credential: String,
        expires: String,
        signature: String
    ) {
        self.algorithm = algorithm
        self.date = date
        self.signedHeaders = signedHeaders
        self.credential = credential
        self.expires = expires
        self.signature = signature
    }
}

// MARK: - StorePresignedUrlRequestMapper

public class StorePresignedUrlRequestMapper {
    public static func toDto(presignedUrl: String) -> StorePresignedUrlRequestDto {
        var algorithm = ""
        var date = ""
        var signedHeaders = ""
        var credential = ""
        var expires = ""
        var signature = ""

        // presignedUrl에서 '?' 이후의 쿼리 문자열을 추출
        if let range = presignedUrl.range(of: "?") {
            let query = String(presignedUrl[range.upperBound...])
            // '&'로 구분된 각 쿼리 파라미터를 추출
            let queryItems = query.split(separator: "&")

            // 각 쿼리 파라미터를 키-값 쌍으로 분리
            for item in queryItems {
                let pair = item.split(separator: "=")
                if pair.count == 2 {
                    let key = pair[0]
                    let value = pair[1]

                    switch key {
                    case "X-Amz-Algorithm":
                        algorithm = String(value)
                    case "X-Amz-Date":
                        date = String(value)
                    case "X-Amz-SignedHeaders":
                        signedHeaders = String(value)
                    case "X-Amz-Credential":
                        credential = String(value)
                    case "X-Amz-Expires":
                        expires = String(value)
                    case "X-Amz-Signature":
                        signature = String(value)
                    default:
                        break
                    }
                }
            }
        }

        return StorePresignedUrlRequestDto(
            algorithm: algorithm,
            date: date,
            signedHeaders: signedHeaders,
            credential: credential,
            expires: expires,
            signature: signature
        )
    }
}
