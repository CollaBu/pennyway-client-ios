

import Foundation

class DefaultMakeChatRoomRepository: MakeChatRoomRepository {
    func makeChatRoom(roomData: MakeChatRoomItemModel, completion: @escaping (Result<MakeChatRoomResponseDto, Error>) -> Void) {
        let parserData = parseChatroomUrl(from: roomData.backgroundImageUrl ?? "")

        Log.debug("DefaultMakeChatRoomRepository: title: \(roomData.title), description: \(roomData.description), password: \(roomData.password), backgroundImageUrl: \(parserData)")

        let makeChatRoomRequestDto = MakeChatRoomRequestDto(
            title: roomData.title,
            description: roomData.description ?? "",
            password: roomData.password ?? "",
            backgroundImageUrl: parserData ?? ""
        )

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

    /// delete이후 문자열만 추출하는 함수
    private func parseChatroomUrl(from presignedUrl: String) -> String {
        // '?' 앞의 URL 부분만 추출
        let extractedUrl = extractPresignedUrl(from: presignedUrl)

        // 'delete/' 이후의 문자열만 추출
        if let range = extractedUrl.range(of: "delete/") {
            return String(extractedUrl[range.lowerBound...])
        }
        return extractedUrl
    }

    private func extractPresignedUrl(from presignedUrl: String) -> String {
        // '?' 문자가 있는지 확인하고, 그 앞부분의 URL만 반환
        if let range = presignedUrl.range(of: "?") {
            return String(presignedUrl[..<range.lowerBound])
        }
        return presignedUrl
    }
}
