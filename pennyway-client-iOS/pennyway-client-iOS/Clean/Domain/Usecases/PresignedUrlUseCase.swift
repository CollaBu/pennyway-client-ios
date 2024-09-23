//
//  PresignedUrlUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation
import UIKit

// MARK: - PresignedUrlUseCase

protocol PresignedUrlUseCase {
    func generate(type: String, ext: String, image: UIImage)
}

// MARK: - DefaultPresignedUrlUseCase

/// Presigned URL을 생성하는 Use Case 기본 구현
class DefaultPresignedUrlUseCase: PresignedUrlUseCase {
    private let repository: PresignedUrlRepository

    init(repository: PresignedUrlRepository) {
        self.repository = repository
    }

    /// Presigned URL을 생성하는 메서드의 구현
    /// - Parameters:
    ///   - model: Presigned URL을 생성하기 위한 요청 모델
    ///   - completion: 성공 시 PresignedUrlModel 반환, 실패 시 Error 반환
    ///   - image: 업로드할 UIImage
    func generate(type: String, ext: String, image: UIImage) {
        let presignedUrlModel = PresignedUrlType(type: type, ext: ext)

        repository.generatePresignedUrl(model: presignedUrlModel) { result in
            switch result {
            case let .success(presignedUrl):
                Log.debug("Presigned URL 생성 성공: \(presignedUrl.presignedUrl)")

                // Presigned URL을 사용하여 이미지 업로드
                self.upload(presignedUrl: presignedUrl.presignedUrl, image: image) { result in
                    switch result {
                    case .success:
                        Log.debug("이미지 업로드 성공")
                    case let .failure(error):
                        Log.error("이미지 업로드 실패: \(error)")
                    }
                }
            case let .failure(error):
                Log.error("Presigned URL 생성 실패: \(error)")
            }
        }
    }

    /// Presigned URL을 사용해 이미지를 업로드하는 메서드
    /// - Parameters:
    ///   - presignedUrl: 서버로부터 받은 presigned URL
    ///   - image: 업로드할 UIImage
    ///   - completion: 성공 시 Void, 실패 시 Error 반환
    private func upload(presignedUrl: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        let payload = extractPresignedUrl(from: presignedUrl)

        repository.uploadPresignedUrl(payload: payload, image: image, presignedUrl: presignedUrl, completion: completion)
    }

    private func extractPresignedUrl(from presignedUrl: String) -> String {
        // '?' 문자가 있는지 확인하고, 그 앞부분의 URL만 반환
        if let range = presignedUrl.range(of: "?") {
            return String(presignedUrl[..<range.lowerBound])
        }
        return presignedUrl
    }
}
