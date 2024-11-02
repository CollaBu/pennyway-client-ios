//
//  DefaultSearchChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//
//
// import Foundation
//
// class DefaultSearchChatRoomRepository: SearchChatRoomRepository {
//    func execute(completion: @escaping (Result<SearchChatRoomData, any Error>) -> Void) {
//        ChatAlamofire.shared.makeChatRoom(makeChatRoomRequestDto) { result in
//            switch result {
//            case let .success(data):
//                if let responseData = data {
//                    do {
//                        let response = try JSONDecoder().decode(MakeChatRoomResponseDto.self, from: responseData)
//                        Log.debug("[DefaultMakeChatRoomRepository]: 채팅방 생성 확정 api 성공: \(response)")
//                        completion(.success(response.data))
//                    } catch {
//                        Log.fault("Error parsing response JSON: \(error)")
//                        completion(.failure(error))
//                    }
//                }
//            case let .failure(error):
//                if let StatusSpecificError = error as? StatusSpecificError {
//                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
//                } else {
//                    Log.error("Network request failed: \(error)")
//                }
//                completion(.failure(error))
//            }
//        }
//    }
// }
