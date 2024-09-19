//
//  PresignedUrlUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation
import UIKit

// MARK: - PresignedUrlUseCase

protocol GeneratePresignedUrlUseCase {
    func execute(completion: @escaping (Result<GeneratePresignedUrlResponseDto, Error>) -> Void)
}

class DefaultGeneratePresignedUrlUseCase: GeneratePresignedUrlUseCase {
    private let repository: PresignedUrlProtocol

    init(repository: PresignedUrlProtocol) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<GeneratePresignedUrlResponseDto, Error>) -> Void) {
        let requestDto = GeneratePresigendUrlRequestDto(type: ImageType.profile.rawValue, ext: Ext.jpeg.rawValue)
        repository.generatePresignedUrl(requestDto: requestDto, completion: completion)
    }
}

protocol StorePresignedUrlUseCase {
    func execute(payload: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
}

class DefaultStorePresignedUrlUseCase: StorePresignedUrlUseCase {
    private let repository: PresignedUrlProtocol

    init(repository: PresignedUrlProtocol) {
        self.repository = repository
    }

    func execute(payload: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        let presignedUrl = extractPresignedUrl(from: payload)
        
        repository.storePresignedUrl(payload: payload, image: image, presignedUrl: presignedUrl, completion: completion)
    }
    
    private func extractPresignedUrl(from presignedUrl: String) -> String {
        if let range = presignedUrl.range(of: "?") {
            return String(presignedUrl[..<range.lowerBound])
        }
        return presignedUrl
    }
}
