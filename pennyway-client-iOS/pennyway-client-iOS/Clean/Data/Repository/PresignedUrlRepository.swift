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
            case let .success(data):
                if let responseData = data {
                    do {
                        // Data를 GeneratePresignedUrlResponseDto로 디코딩
                        let responseDto = try JSONDecoder().decode(GeneratePresignedUrlResponseDto.self, from: responseData)
                        
                        // 응답 DTO를 Model로 변환
                        let presignedUrlModel = PresignedUrlModel(presignedUrl: responseDto.presignedUrl)
                        completion(.success(presignedUrlModel))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func storePresignedUrl(payload: String, image: UIImage, presignedUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // presignedUrl에서 필요한 데이터를 추출하여 StorePresignedUrlRequestDto로 변환
        let storePresignedUrlRequestDto = createStorePresignedUrlRequestDto(from: presignedUrl)
        
        ObjectStorageAlamofire.shared.storePresignedUrl(payload, image, storePresignedUrlRequestDto) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
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
