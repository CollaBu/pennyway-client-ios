

import Foundation

class DefaultMakeChatRoomRepository: MakeChatRoomRepository {
//    /// 'delete/' 이후의 문자열만 추출하는 메서드
//    private func parseChatroomUrl(from presignedUrl: String) -> String {
//        // '?' 앞의 URL 부분만 추출
//        let extractedUrl = extractPresignedUrl(from: presignedUrl)
//
//        // 'delete/' 이후의 문자열만 추출
//        if let range = extractedUrl.range(of: "delete/") {
//            return String(extractedUrl[range.upperBound...])
//        }
//        return extractedUrl
//    }
//    
//    private func extractPresignedUrl(from presignedUrl: String) -> String {
//        // '?' 문자가 있는지 확인하고, 그 앞부분의 URL만 반환
//        if let range = presignedUrl.range(of: "?") {
//            return String(presignedUrl[..<range.lowerBound])
//        }
//        return presignedUrl
//    }

    func makeChatRoom(presignedUrl: String, chatRoomId: Int64, completion: @escaping (Result<MakeChatRoomResponseDto, Error>) -> Void) {
        let parsedPath = extractPathComponent(from: presignedUrl) ?? ""
        let backgroundImageUrl = "delete/chatroom/\(chatRoomId)/\(parsedPath)"
        Log.debug("backgroundImageUrl:\(backgroundImageUrl)")

        let makeChatRoomRequestDto = MakeChatRoomRequestDto(backgroundImageUrl: backgroundImageUrl)

        ChatAlamofire.shared.makeChatRoom(makeChatRoomRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(MakeChatRoomResponseDto.self, from: responseData)
                        Log.debug("[DefaultMakeChatRoomRepository]: 채팅방 생성 확정 api 성공: \(response)")
                        completion(.success(response))
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(.failure(error))
            }
        }
    }

    /// 채팅방 생성 대기 api
    func pendChatRoom(roomData: MakeChatRoomItemModel, completion: @escaping (Result<Int64, Error>) -> Void) {
        let pendChatRoomRequestDto = PendChatRoomRequestDto(title: roomData.title, description: roomData.description, password: roomData.password)

        ChatAlamofire.shared.pendChatRoom(pendChatRoomRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(PendChatRoomResponseDto.self, from: responseData)
                        Log.debug("[DefaultMakeChatRoomRepository]: 채팅방 생성 대기 api 성공: \(response)")
                        completion(.success(response.data.chatRoomId))
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(.failure(error))
            }
        }
    }

    func extractPathComponent(from urlString: String) -> String? {
        // URL 객체 생성
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }

        // URL의 경로 추출
        let fullPath = url.path

        // 경로에서 호스트 부분 제거
        let pathComponents = fullPath.split(separator: "/")
        guard pathComponents.count > 1 else {
            return nil
        }

        // 첫 번째 컴포넌트 (빈 문자열)와 호스트 부분을 제외한 나머지 경로 컴포넌트 결합
        let trimmedPath = pathComponents.dropFirst(1).joined(separator: "/")

        return trimmedPath
    }
}
