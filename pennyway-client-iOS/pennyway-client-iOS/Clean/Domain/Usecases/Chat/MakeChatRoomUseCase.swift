import Foundation
import UIKit

// MARK: - MakeChatRoomUseCase

/// 채팅방 생성 usecase를 정의하는 프로토콜
protocol MakeChatRoomUseCase {
    func createChatRoomWithImage(roomData: MakeChatRoomItemModel, image: UIImage, completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultMakeChatRoomUseCase

class DefaultMakeChatRoomUseCase: MakeChatRoomUseCase {
    private let repository: MakeChatRoomRepository
    private let urlRepository: PresignedUrlRepository

    init(repository: MakeChatRoomRepository, urlRepository: PresignedUrlRepository) {
        self.repository = repository
        self.urlRepository = urlRepository
    }

    /// 채팅방 대기 생성
    func pend(roomData: MakeChatRoomItemModel, completion: @escaping (Result<Int64, Error>) -> Void) {
        return repository.pendChatRoom(roomData: roomData) { result in
            completion(result)
        }
    }

    /// 채팅방 생성 확정
    func execute(from url: String, chatRoomId _: Int64, completion: @escaping (Bool) -> Void) {
        repository.makeChatRoom(presignedUrl: url) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    /// Presigned URL을 생성하는 메서드의 구현
    /// - Parameters:
    ///   - type: 파일의 타입
    ///   - ext: 파일의 확장자 (예: "jpg")
    ///   - model: Presigned URL을 생성하기 위한 요청 모델
    ///   - completion: 성공 시 PresignedUrlModel 반환, 실패 시 Error 반환
    ///   - image: 업로드할 UIImage
    func generatePrisignedUrl(type: String, ext: String, image _: UIImage, chatRoomId: Int64?, completion: @escaping (Result<String, Error>) -> Void) {
        Log.debug("generatePrisignedUrl 호출됨, chatRoomId: \(chatRoomId)")

        let presignedUrlModel = PresignedUrlType(type: type, ext: ext, chatRoomId: chatRoomId)
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

    /// 채팅방 이미지를 업로드하고 채팅방 생성 확정 요청하는 메서드
    private func uploadChatRoomImage(payload: String, presignedUrl: String, chatRoomId _: Int64, image: UIImage, completion: @escaping (Result<MakeChatRoomResponseDto, Error>) -> Void) {
        upload(payload: payload, presignedUrl: presignedUrl, image: image) { result in
            switch result {
            case .success():
                Log.debug("[MakeChatRoomUseCase]-채팅방 이미지 업로드 성공")
                // 채팅방 생성 확정 API 호출
                self.repository.makeChatRoom(presignedUrl: presignedUrl) { result in
                    switch result {
                    case let .success(response):
                        Log.debug("[MakeChatRoomUseCase]-채팅방 생성 확정 성공: \(response)")
                        completion(.success(response))
                    case let .failure(error):
                        Log.error("채팅방 생성 확정 실패: \(error)")
                        completion(.failure(error))
                    }
                }

            case let .failure(error):
                Log.error("채팅방 이미지 업로드 실패: \(error)")
                completion(.failure(error))
            }
        }
    }

    /// Presigned URL을 생성하고 이미지를 업로드한 후 채팅방 생성을 확정하는 함수
    func createChatRoomWithImage(roomData: MakeChatRoomItemModel, image: UIImage, completion: @escaping (Bool) -> Void) {
        // 1. 채팅방 대기 생성 (pend)
        pend(roomData: roomData) { pendResult in
            switch pendResult {
            case let .success(chatRoomId):
                // 2. Presigned URL 생성 및 이미지 업로드
                Log.debug("pend 요청 성공, chatRoomId: \(chatRoomId)")
                Log.debug("chatRoomId:\(chatRoomId)")

                self.generatePrisignedUrl(type: ImageType.chatroomProfile.rawValue, ext: Ext.jpeg.rawValue, image: image, chatRoomId: chatRoomId) { generateResult in

                    Log.debug("createChatRoomWithImage내부에서 generatePresignedUrl까지 실행됨")
                    switch generateResult {
                    case let .success(presignedUrl):
                        // 3. 이미지 업로드 후 채팅방 생성 확정
                        Log.debug("presignedUrl:\(presignedUrl)")
                        Log.debug("chatRoomId1:\(chatRoomId)")
                        self.uploadChatRoomImage(payload: presignedUrl, presignedUrl: presignedUrl, chatRoomId: chatRoomId, image: image) { uploadResult in
                            switch uploadResult {
                            case .success:
                                // 4. 채팅방 생성 확정 성공
                                Log.debug("chatRoomId2:\(chatRoomId)")
                                Log.debug("채팅방 생성 확정 성공")
                                completion(true)
                            case .failure:
                                completion(false)
                            }
                        }
                    case let .failure(error):
                        Log.error("generatePrisignedUrl 요청 오류: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                Log.error("pend요청 에러:\(error)")
                completion(false)
            }
        }
    }

    private func upload(payload: String, presignedUrl: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        urlRepository.uploadPresignedUrl(payload: payload, image: image, presignedUrl: presignedUrl, completion: completion)
    }
}
