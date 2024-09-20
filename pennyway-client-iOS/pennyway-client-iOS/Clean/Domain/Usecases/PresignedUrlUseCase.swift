//
//  PresignedUrlUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation
import UIKit

// MARK: - GeneratePresignedUrlUseCase

/// 프로필 이미지 등을 업로드할 때 presigned URL을 생성하는 Use Case 프로토콜
protocol GeneratePresignedUrlUseCase {
    func execute(model: PresignedUrlTypeModel, completion: @escaping (Result<PresignedUrlModel, Error>) -> Void)
}

// MARK: - DefaultGeneratePresignedUrlUseCase

/// Presigned URL을 생성하는 Use Case 기본 구현
class DefaultGeneratePresignedUrlUseCase: GeneratePresignedUrlUseCase {
    private let repository: PresignedUrlRepository

    init(repository: PresignedUrlRepository) {
        self.repository = repository
    }

    /// Presigned URL을 생성하는 메서드의 구현
    /// - Parameters:
    ///   - model: Presigned URL을 생성하기 위한 요청 모델
    ///   - completion: 성공 시 PresignedUrlModel 반환, 실패 시 Error 반환
    func execute(model: PresignedUrlTypeModel, completion: @escaping (Result<PresignedUrlModel, Error>) -> Void) {
        repository.generatePresignedUrl(model: model) { result in
            switch result {
            case let .success(presignedUrlModel):
                completion(.success(presignedUrlModel))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - StorePresignedUrlUseCase

/// presigned URL을 사용하여 이미지를 업로드하는 Use Case 프로토콜
protocol StorePresignedUrlUseCase {
    func execute(payload: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - DefaultStorePresignedUrlUseCase

/// presigned URL을 사용하여 이미지를 업로드하는 Use Case 기본 구현
class DefaultStorePresignedUrlUseCase: StorePresignedUrlUseCase {
    private let repository: PresignedUrlRepository

    init(repository: PresignedUrlRepository) {
        self.repository = repository
    }

    /// Presigned URL을 사용해 이미지를 업로드하는 메서드
    /// - Parameters:
    ///   - payload: 서버로부터 받은 presigned URL
    ///   - image: 업로드할 UIImage
    ///   - completion: 성공 시 Void, 실패 시 Error 반환
    func execute(payload: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        let presignedUrl = extractPresignedUrl(from: payload)

        repository.storePresignedUrl(payload: payload, image: image, presignedUrl: presignedUrl, completion: completion)
    }

    private func extractPresignedUrl(from presignedUrl: String) -> String {
        // '?' 문자가 있는지 확인하고, 그 앞부분의 URL만 반환
        if let range = presignedUrl.range(of: "?") {
            return String(presignedUrl[..<range.lowerBound])
        }
        return presignedUrl
    }
}
