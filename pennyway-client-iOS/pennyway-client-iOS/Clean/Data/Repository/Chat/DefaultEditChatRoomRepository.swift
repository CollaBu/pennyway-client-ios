//
//  DefaultEditChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

import Foundation

class DefaultEditChatRoomRepository: EditChatRoomRepository {
    private let cdnUrl = Url.cdnUrl

    func getChatAdminMode(chatRoomId: Int64, completion: @escaping (Result<AdminModeChatRoom, Error>) -> Void) {
        ChatRoomAlamofire.shared.getChatAdminMode(chatRoomId) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("[DefaultEditChatRoomRepository]: 응답 JSON 출력: \(jsonString)")
                    } else {
                        Log.warning("[DefaultEditChatRoomRepository]: 응답 데이터를 문자열로 변환할 수 없습니다.")
                    }
                    do {
                        let response = try JSONDecoder().decode(GetChatAdminModeResponseDto.self, from: responseData)
                        Log.debug("[DefaultEditChatRoomRepository]: 채팅방 관리자 모드 조회 api 성공: \(response)")

                        let chatRoomdata = GetChatAdminModeResponseDto.to(dto: response, cdnUrl: self.cdnUrl)

                        Log.debug("[DefaultEditChatRoomRepository]: 데이터 확인:  \(chatRoomdata)")

                        completion(.success(chatRoomdata))
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

    func editChatRoom(roomData: AdminModeChatRoomItemModel, completion: @escaping (Result<MakeChatRoomData, Error>) -> Void) {
        let parserData = parseChatroomUrl(from: roomData.backgroundImageUrl ?? "")

        let editChatRoomRequestDto = EditChatRoomRequestDto(
            title: roomData.title,
            description: roomData.description?.isEmpty == true ? nil : roomData.description!,
            password: roomData.password?.isEmpty == true ? nil : roomData.password!,
            backgroundImageUrl: parserData.isEmpty ? nil : parserData
        )

        Log.debug("[DefaultEditChatRoomRepository] 요청값 \(editChatRoomRequestDto)")

        ChatAlamofire.shared.editChatRoom(roomData.chatRoomId, editChatRoomRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(MakeChatRoomResponseDto.self, from: responseData)
                        Log.debug("[DefaultEditChatRoomRepository]: 채팅방 수정 api 성공: \(response)")
                        completion(.success(response.data))
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
