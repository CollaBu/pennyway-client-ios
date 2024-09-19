//
//  PresignedUrlRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation
import UIKit

class DefaultPresignedUrlRepository: PresignedUrlProtocol {
    
    func generatePresignedUrl(model: PresignedUrlTypeModel, completion: @escaping (Result<PresignedUrlModel, Error>) -> Void) {
        // Model을 DTO로 변환
        let requestDto = model.toDto()
        
        // DTO로 API 호출 (예시)
        ObjectStorageAlamofire.shared.generatePresignedUrl(requestDto) { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        // Data를 GeneratePresignedUrlResponseDto로 디코딩
                        let responseDto = try JSONDecoder().decode(GeneratePresignedUrlResponseDto.self, from: responseData)
                        
                        // 응답 DTO를 Model로 변환
                        let presignedUrlModel = PresignedUrlModel(presignedUrl: responseDto.presignedUrl)
                        completion(.success(presignedUrlModel))
                    } catch {
                        completion(.failure(error)) // 디코딩 실패 시 에러 처리
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func storePresignedUrl(payload: String, image: UIImage, presignedUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let storePresignedUrlRequestDto = createStorePresignedUrlRequestDto(from: presignedUrl)
        
        ObjectStorageAlamofire.shared.storePresignedUrl(payload, image, storePresignedUrlRequestDto) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createStorePresignedUrlRequestDto(from presignedUrl: String) -> StorePresignedUrlRequestDto {
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
