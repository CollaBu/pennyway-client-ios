
import SwiftUI

class PresignedUrlViewModel: ObservableObject {
    var presignedUrl = ""
    var payload = ""
    @Published var image: UIImage? = UIImage(named: "icon_illust_no_image")!
    
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
        
        Log.debug(payload)
        Log.debug(storePresignedUrlRequestDto)

        if image != nil {
            StorageAlamofire.shared.storePresignedUrl(payload, image!, storePresignedUrlRequestDto) { result in
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
    }
    
    func createStorePresignedUrlRequestDto(from presignedUrl: String) -> StorePresignedUrlRequestDto {
        if let payloadURL = URL(string: presignedUrl),
           let components = URLComponents(url: payloadURL, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems
        {
            // 필요한 값을 추출, 값이 없을 경우 빈 문자열을 기본값으로 설정
            let algorithm = queryItems[0].value ?? ""
            let date = queryItems[1].value ?? ""
            let signedHeaders = queryItems[2].value ?? ""
            let credential = queryItems[3].value ?? ""
            let expires = queryItems[4].value ?? ""
            let signature = queryItems[5].value ?? ""
            
            return StorePresignedUrlRequestDto(
                algorithm: algorithm,
                date: date,
                signedHeaders: signedHeaders,
                credential: credential,
                expires: expires,
                signature: signature
            )
        }
        return StorePresignedUrlRequestDto(
            algorithm: "",
            date: "",
            signedHeaders: "",
            credential: "",
            expires: "",
            signature: ""
        )
    }
}
