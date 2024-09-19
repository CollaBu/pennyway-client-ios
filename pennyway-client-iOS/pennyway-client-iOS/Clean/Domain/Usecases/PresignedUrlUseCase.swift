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
    func execute(model: PresignedUrlTypeModel, completion: @escaping (Result<PresignedUrlModel, Error>) -> Void)
}

class DefaultGeneratePresignedUrlUseCase: GeneratePresignedUrlUseCase {
    private let repository: PresignedUrlProtocol

    init(repository: PresignedUrlProtocol) {
        self.repository = repository
    }

    func execute(model: PresignedUrlTypeModel, completion: @escaping (Result<PresignedUrlModel, Error>) -> Void) {
        repository.generatePresignedUrl(model: model) { result in
            switch result {
            case .success(let presignedUrlModel):
                completion(.success(presignedUrlModel))

            case .failure(let error):
                completion(.failure(error))
            }
        }
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
