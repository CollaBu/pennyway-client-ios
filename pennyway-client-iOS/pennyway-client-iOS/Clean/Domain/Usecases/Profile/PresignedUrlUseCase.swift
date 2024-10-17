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
    func generate(entryPoint: ImageEntryPoint, type: String, ext: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

// MARK: - DefaultPresignedUrlUseCase

/// Presigned URL을 생성하는 Use Case 기본 구현
class DefaultPresignedUrlUseCase: PresignedUrlUseCase {
    private let urlRepository: PresignedUrlRepository
    private let imageRepository: ProfileImageRepository

    init(urlRepository: PresignedUrlRepository, imageRepository: ProfileImageRepository) {
        self.urlRepository = urlRepository
        self.imageRepository = imageRepository
    }

    /// Presigned URL을 생성하는 메서드의 구현
    /// - Parameters:
    ///   - entryPoint: 이미지 업로드 Entry Point (예: profile, chatroom)
    ///   - type: 파일의 타입
    ///   - ext: 파일의 확장자 (예: "jpg")
    ///   - model: Presigned URL을 생성하기 위한 요청 모델
    ///   - completion: 성공 시 PresignedUrlModel 반환, 실패 시 Error 반환
    ///   - image: 업로드할 UIImage
    func generate(entryPoint: ImageEntryPoint, type: String, ext: String, image: UIImage, completion _: @escaping (Result<String, Error>) -> Void) {
        let presignedUrlModel = PresignedUrlType(type: type, ext: ext, chatRoomId: nil)

        urlRepository.generatePresignedUrl(model: presignedUrlModel) { result in
            switch result {
            case let .success(presignedUrl):
                Log.debug("[Presigned URL]-Presigned URL 생성 성공: \(presignedUrl.presignedUrl)")

                let payload = self.extractPresignedUrl(from: presignedUrl.presignedUrl)

                if entryPoint == .profile {
                    // Presigned URL을 사용하여 이미지 업로드
                    self.upload(payload: payload, presignedUrl: presignedUrl.presignedUrl, image: image) { result in
                        switch result {
                        case .success:
                            Log.debug("[Presigned URL]-이미지 업로드 성공")

                            self.update(from: payload) { result in

                                switch result {
                                case let .success(response):
                                    Log.debug("[PresignedUrlUseCase]-프로필 이미지 업데이트 성공: \(response)")

                                    self.loadImage(from: payload) { loadResult in
                                        switch loadResult {
                                        case let .success(image):
                                            DispatchQueue.main.async {
                                                Log.debug("[PresignedUrlUseCase]-이미지 업데이트 성공")
                                            }
                                        case let .failure(error):
                                            Log.debug("[PresignedUrlUseCase]-이미지 로드 실패: \(error)")
                                        }
                                    }

                                case let .failure(error):
                                    Log.debug("[PresignedUrlUseCase]-프로필 이미지 업데이트 실패: \(error)")
                                }
                            }

                        case let .failure(error):
                            Log.error("이미지 업로드 실패: \(error)")
                        }
                    }
                } else if entryPoint == .chatRoom {
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
    private func upload(payload: String, presignedUrl: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        urlRepository.uploadPresignedUrl(payload: payload, image: image, presignedUrl: presignedUrl, completion: completion)
    }

    private func extractPresignedUrl(from presignedUrl: String) -> String {
        // '?' 문자가 있는지 확인하고, 그 앞부분의 URL만 반환
        if let range = presignedUrl.range(of: "?") {
            return String(presignedUrl[..<range.lowerBound])
        }
        return presignedUrl
    }

    private func update(from url: String, completion: @escaping (Result<String, Error>) -> Void) {
        imageRepository.uploadProfileImage(payload: url, completion: completion)
    }

    func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imageRepository.loadProfileImage(from: url, completion: completion)
    }

}
