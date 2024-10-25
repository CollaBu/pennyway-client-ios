//
//  DefaultPresignedUrlRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation
import UIKit

class DefaultPresignedUrlRepository: PresignedUrlRepository {
    func generatePresignedUrl(model: PresignedUrlType, completion: @escaping (Result<PresignedUrl, Error>) -> Void) {
        // Model을 DTO로 변환
        let requestDto = GeneratePresigendUrlRequestDto.from(model: model)

        // DTO로 API 호출
        ObjectStorageAlamofire.shared.generatePresignedUrl(requestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        // Data를 GeneratePresignedUrlResponseDto로 디코딩
                        let responseDto = try JSONDecoder().decode(GeneratePresignedUrlResponseDto.self, from: responseData)

                        // 응답 DTO를 Model로 변환
                        let presignedUrlModel = PresignedUrl(presignedUrl: responseDto.presignedUrl)
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

    func uploadPresignedUrl(payload: String, image: UIImage, presignedUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // presignedUrl에서 필요한 데이터를 추출하여 StorePresignedUrlRequestDto로 변환

        let storePresignedUrlRequestDto = StorePresignedUrlRequestMapper.toDto(presignedUrl: presignedUrl)

        ObjectStorageAlamofire.shared.storePresignedUrl(payload, image, storePresignedUrlRequestDto) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
