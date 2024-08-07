
import SwiftUI

class PresignedUrlViewModel: ObservableObject {
    
    let presignedUrl = ""
    var payload = ""
    @Published var image: UIImage = UIImage(named: "icon_illust_no_image")!
    
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
                        let presignedUrl = response.presignedUrl
                        Log.debug("presigned_url 발급 성공 \(presignedUrl)")
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

        StorageAlamofire.shared.storePresignedUrl(payload, image, storePresignedUrlRequestDto){ result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("presigned_url 발급 성공 \(jsonString)")
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
    }
    
    func createStorePresignedUrlRequestDto(from presignedUrl: String) -> StorePresignedUrlRequestDto {
        guard let urlComponents = URLComponents(string: presignedUrl),
              let queryItems = urlComponents.queryItems else {
            return StorePresignedUrlRequestDto(
                algorithm: "",
                credential: "",
                date: "",
                expires: "",
                signature: "",
                signedHeaders: ""
            )
        }
        
        var parameters: [String: String] = [:]
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        // 필요한 값을 추출, 값이 없을 경우 빈 문자열을 기본값으로 설정
        let algorithm = parameters["X-Amz-Algorithm"] ?? ""
        let credential = parameters["X-Amz-Credential"] ?? ""
        let date = parameters["X-Amz-Date"] ?? ""
        let expires = parameters["X-Amz-Expires"] ?? ""
        let signature = parameters["X-Amz-Signature"] ?? ""
        let signedHeaders = parameters["X-Amz-SignedHeaders"] ?? ""
        
        return StorePresignedUrlRequestDto(
            algorithm: algorithm,
            credential: credential,
            date: date,
            expires: expires,
            signature: signature,
            signedHeaders: signedHeaders
        )
    }
}
