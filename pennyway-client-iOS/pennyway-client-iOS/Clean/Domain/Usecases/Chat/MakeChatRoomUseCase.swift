import Foundation
import UIKit

// MARK: - MakeChatRoomUseCase

/// 채팅방 생성 usecase를 정의하는 프로토콜
protocol MakeChatRoomUseCase {
    func uploadImage(roomData: MakeChatRoomItemModel, image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func makeChatRoom(roomData: MakeChatRoomItemModel, completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultMakeChatRoomUseCase

class DefaultMakeChatRoomUseCase: MakeChatRoomUseCase {
    private let repository: MakeChatRoomRepository
    private let urlRepository: PresignedUrlRepository

    init(repository: MakeChatRoomRepository, urlRepository: PresignedUrlRepository) {
        self.repository = repository
        self.urlRepository = urlRepository
    }

    /// Presigned URL을 생성하는 메서드의 구현
    /// - Parameters:
    ///   - type: 파일의 타입
    ///   - ext: 파일의 확장자 (예: "jpg")
    ///   - model: Presigned URL을 생성하기 위한 요청 모델
    ///   - completion: 성공 시 PresignedUrlModel 반환, 실패 시 Error 반환
    ///   - image: 업로드할 UIImage
    func generatePrisignedUrl(type: String, ext: String, image _: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let presignedUrlModel = PresignedUrlType(type: type, ext: ext)
        urlRepository.generatePresignedUrl(model: presignedUrlModel) { result in
            switch result {
            case let .success(presignedUrl):
                Log.debug("[Presigned URL]-Presigned URL 생성 성공: \(presignedUrl.presignedUrl)")
                completion(.success(presignedUrl.presignedUrl)) // 여기서 completion 호출

            case let .failure(error):
                Log.error("Presigned URL 생성 실패: \(error)")
                completion(.failure(error)) // 실패 시에도 completion 호출
            }
        }
    }

    func makeChatRoom(roomData: MakeChatRoomItemModel, completion: @escaping (Bool) -> Void) {
        repository.makeChatRoom(roomData: roomData) { result in
            switch result {
            case let .success(response):
                Log.debug("[MakeChatRoomUseCase]-채팅방 생성 확정 성공: \(response)")
                completion(true)
            case let .failure(error):
                Log.error("[MakeChatRoomUseCase]-채팅방 생성 확정 실패: \(error)")
                completion(false)
            }
        }
    }

    /// Presigned URL을 생성하고 이미지를 업로드한 후 채팅방 생성을 확정하는 함수
    func uploadImage(roomData _: MakeChatRoomItemModel, image: UIImage, completion: @escaping
        (Result<String, Error>) -> Void)
    {
        // 1. Presigned URL 생성 및 이미지 업로드
        generatePrisignedUrl(type: ImageType.chatroomProfile.rawValue, ext: Ext.jpeg.rawValue, image: image) { generateResult in

            Log.debug("createChatRoomWithImage내부에서 generatePresignedUrl까지 실행됨")
            switch generateResult {
            case let .success(presignedUrl):
                Log.debug("presignedUrl:\(presignedUrl)")

                // 2. 이미지 업로드
                self.uploadImage(payload: presignedUrl, presignedUrl: presignedUrl, image: image) { uploadResult in
                    switch uploadResult {
                    case .success:
                        // 이미지 업로드 성공 시 presignedUrl 반환
                        completion(.success(presignedUrl))
                    case let .failure(uploadError):
                        // 이미지 업로드 실패 시 오류 반환
                        Log.error("[MakeChatRoomUseCase]: 이미지 업로드 실패, 오류: \(uploadError)")
                        completion(.failure(uploadError))
                    }
                }

            case let .failure(error):
                Log.error("generatePrisignedUrl 요청 오류: \(error)")
                completion(.failure(error))
            }
        }
    }

    private func upload(payload: String, presignedUrl: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        urlRepository.uploadPresignedUrl(payload: payload, image: image, presignedUrl: presignedUrl, completion: completion)
    }

    /// 채팅방 이미지를 업로드하고 채팅방 생성 확정 요청하는 메서드
    private func uploadImage(payload: String, presignedUrl: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        upload(payload: payload, presignedUrl: presignedUrl, image: image) { result in
            switch result {
            case .success:
                Log.debug("[MakeChatRoomUseCase]: presignedUrl: \(presignedUrl)")
                completion(.success(presignedUrl))
            case let .failure(error):
                Log.error("채팅방 이미지 업로드 실패: \(error)")
                completion(.failure(error)) // 실패 시 에러 반환
            }
        }
    }
}
