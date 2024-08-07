
import SwiftUI

class PresignedUrlViewModel: ObservableObject {
    
    let presignedUrl = ""
    
    /// presigned url 발급
    func generatePresignedUrlApi(completion: @escaping (Bool) -> Void) {
        let generatePresigendUrlRequestDto = GeneratePresigendUrlRequestDto(type: ImageType.profile.rawValue, ext: Ext.jpg.rawValue)
        

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
}
