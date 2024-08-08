
import SwiftUI

class PresignedUrlViewModel: ObservableObject {
    var presignedUrl = ""//발급받은 presigned url 저장
    var payload = ""//presigned url의 payload 저장
    @Published var image: UIImage? = UIImage(named: "icon_illust_no_image_no_margin")!

    /// presigned url 발급
    func generatePresignedUrlApi(completion: @escaping (Bool) -> Void) {
        let generatePresigendUrlRequestDto = GeneratePresigendUrlRequestDto(type: ImageType.profile.rawValue, ext: Ext.jpeg
            .rawValue)

        StorageAlamofire.shared.generatePresignedUrl(generatePresigendUrlRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GeneratePresignedUrlResponseDto.self, from: responseData)
                        self.presignedUrl = response.presignedUrl
                        Log.debug("presigned_url 발급 성공 \(self.presignedUrl)")
                        completion(true)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }

    /// presigned url 저장
    func storePresignedUrlApi(completion: @escaping (Bool) -> Void) {
        if let range = presignedUrl.range(of: "?") {
            payload = String(presignedUrl[..<range.lowerBound])
        } else {
            payload = presignedUrl
        }

        let storePresignedUrlRequestDto = createStorePresignedUrlRequestDto(from: presignedUrl)

        Log.debug("payload: \(payload)")

        if image != nil {
            StorageAlamofire.shared.storePresignedUrl(payload, image!, storePresignedUrlRequestDto) { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("presigned_url 저장 성공 \(jsonString)")
                        }
                        completion(true)
                    }
                case let .failure(error):
                    if let StatusSpecificError = error as? StatusSpecificError {
                        Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                    } else {
                        Log.error("Network request failed: \(error)")
                    }
                    completion(false)
                }
            }
        } else {
            Log.error("선택한 image가 없음")
        }
    }

    //발급받은 presigned url 퀄리별로 자르기
    func createStorePresignedUrlRequestDto(from presignedUrl: String) -> StorePresignedUrlRequestDto {
        var algorithm = ""
        var date = ""
        var signedHeaders = ""
        var credential = ""
        var expires = ""
        var signature = ""

        if let range = presignedUrl.range(of: "?") {
            let query = String(presignedUrl[range.upperBound...])
            let queryItems = query.split(separator: "&")

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
