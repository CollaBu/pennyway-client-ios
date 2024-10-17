import Foundation
import UIKit

// MARK: - MakeChatRoomUseCase

/// 채팅방 생성 usecase를 정의하는 프로토콜
protocol MakeChatRoomUseCase {
    /// 채팅방 생성 확정 기능을 하는 함수
    func execute(from url: String, chatRoomId: Int64, completion: @escaping (Bool) -> Void)
    
    /// 채팅방 생성 대기 기능을 하는 함수
    /// - Returns: `Int64` 타입으로 채팅방 ID 반환
    func pend(roomData: MakeChatRoomItemModel, completion: @escaping (Result<Int64, Error>) -> Void)
    
    func generate(type: String, ext: String, image: UIImage, completion _: @escaping (Result<String, Error>) -> Void)
    
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
    func execute(from url: String, chatRoomId: Int64, completion: @escaping (Bool) -> Void) {
        repository.makeChatRoom(presignedUrl: url, chatRoomId: chatRoomId) { result in
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
    ///   - entryPoint: 이미지 업로드 Entry Point (예: profile, chatroom)
    ///   - type: 파일의 타입
    ///   - ext: 파일의 확장자 (예: "jpg")
    ///   - model: Presigned URL을 생성하기 위한 요청 모델
    ///   - completion: 성공 시 PresignedUrlModel 반환, 실패 시 Error 반환
    ///   - image: 업로드할 UIImage
    func generate(type: String, ext: String, image _: UIImage, completion _: @escaping (Result<String, Error>) -> Void) {
        let presignedUrlModel = PresignedUrlType(type: type, ext: ext)
            
        urlRepository.generatePresignedUrl(model: presignedUrlModel) { result in
            switch result {
            case let .success(presignedUrl):
                Log.debug("[Presigned URL]-Presigned URL 생성 성공: \(presignedUrl.presignedUrl)")
                    
            case let .failure(error):
                Log.error("Presigned URL 생성 실패: \(error)")
            }
        }
    }
        
    private func extractPresignedUrl(from presignedUrl: String) -> String {
        // '?' 문자가 있는지 확인하고, 그 앞부분의 URL만 반환
        if let range = presignedUrl.range(of: "?") {
            return String(presignedUrl[..<range.lowerBound])
        }
        return presignedUrl
    }

    /// 채팅방 이미지를 업로드하고 채팅방 생성 확정 요청하는 메서드
    private func uploadChatRoomImage(payload: String, presignedUrl: String, chatRoomId: Int64, image: UIImage, completion: @escaping (Result<MakeChatRoomResponseDto, Error>) -> Void) {
        upload(payload: payload, presignedUrl: presignedUrl, image: image) { result in
            switch result {
            case .success:
                Log.debug("[PresignedUrlUseCase]-채팅방 이미지 업로드 성공")
                    
                // 채팅방 생성 확정 API 호출
                self.repository.makeChatRoom(presignedUrl: presignedUrl, chatRoomId: chatRoomId) { result in
                    switch result {
                    case let .success(response):
                        Log.debug("[PresignedUrlUseCase]-채팅방 생성 확정 성공: \(response)")
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
                self.generate(type: ImageType.profile.rawValue, ext: Ext.jpeg.rawValue, image: image) { generateResult in

                    switch generateResult {
                    case let .success(presignedUrl):
                        // 3. 이미지 업로드 후 채팅방 생성 확정
                        let payload = self.extractPresignedUrl(from: presignedUrl)

                        Log.debug("???????")
                        self.uploadChatRoomImage(payload: payload, presignedUrl: presignedUrl, chatRoomId: chatRoomId, image: image) { uploadResult in
                            switch uploadResult {
                            case .success:
                                // 4. 채팅방 생성 확정 성공
                                completion(true)
                            case .failure:
                                completion(false)
                            }
                        }
                    case .failure:
                        completion(false)
                    }
                }
            case .failure:
                completion(false)
            }
        }
    }

    private func upload(payload: String, presignedUrl: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        urlRepository.uploadPresignedUrl(payload: payload, image: image, presignedUrl: presignedUrl, completion: completion)
    }
}
