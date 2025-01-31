//
//  ChatRoomRouter.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 신얀 on 11/5/24.
//

import Alamofire
import Foundation

enum ChatRoomRouter: URLRequestConvertible {
    case getChatRoomDetail(chatRoomId: Int64)
    case getPreviousChat(chatRoomId: Int64, dto: GetPreviousChatRequestDto)
    case getChatMembers(chatRoomId: Int64, dto: GetChatMembersRequestDto)
    case deleteChatRoom(chatRoomId: Int64)
    case banChatMember(chatRoomId: Int64, chatMemberId: Int64)
    case getChatAdminMode(chatRoomId: Int64)
    case turnOnChatRoomAlarm(chatRoomId: Int64)
    case turnOffChatRoomAlarm(chatRoomId: Int64)
    case delegateToAdmin(chatRoomId: Int64, chatMemberId: Int64)
    case deleteChatRoomByAdmin(chatRoomId: Int64)

    var method: HTTPMethod {
        switch self {
        case .getChatRoomDetail, .getPreviousChat, .getChatMembers, .getChatAdminMode:
            return .get
        case .banChatMember, .deleteChatRoom, .deleteChatRoomByAdmin, .turnOffChatRoomAlarm:
            return .delete
        case .delegateToAdmin, .turnOnChatRoomAlarm:
            return .patch
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case let .getChatRoomDetail(chatRoomId), let .deleteChatRoomByAdmin(chatRoomId), let .turnOnChatRoomAlarm(chatRoomId):
            return "v2/chat-rooms/\(chatRoomId)"
        case let .getPreviousChat(chatRoomId, _):
            return "v2/chat-rooms/\(chatRoomId)/chats"
        case let .getChatMembers(chatRoomId, _), let .deleteChatRoom(chatRoomId):
            return "v2/chat-rooms/\(chatRoomId)/chat-members"
        case let .banChatMember(chatRoomId, chatMemberId):
            return "v2/chat-rooms/\(chatRoomId)/chat-members/\(chatMemberId)/ban"
        case let .getChatAdminMode(chatRoomId):
            return "v2/chat-rooms/\(chatRoomId)/admin"
        case let .turnOffChatRoomAlarm(chatRoomId):
            return "v2/chat-rooms/\(chatRoomId)/notification"
        case let .delegateToAdmin(chatRoomId, chatMemberId):
            return "v2/chat-rooms/\(chatRoomId)/chat-members/\(chatMemberId)/delegate"
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getChatRoomDetail, .getPreviousChat, .getChatMembers, .banChatMember, .deleteChatRoom, .getChatAdminMode, .deleteChatRoomByAdmin, .delegateToAdmin, .turnOnChatRoomAlarm, .turnOffChatRoomAlarm:
            return [:]
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .getChatRoomDetail, .banChatMember, .deleteChatRoom, .getChatAdminMode, .deleteChatRoomByAdmin, .delegateToAdmin, .turnOnChatRoomAlarm, .turnOffChatRoomAlarm:
            return [:]
        case let .getPreviousChat(_, dto):
            return try? dto.asDictionary()
        case let .getChatMembers(_, dto):
            // ids 배열을 키-값 쌍으로 분리
            var params: Parameters = [:]
            for (index, id) in dto.ids.enumerated() {
                params["ids[\(index)]"] = "\(id)"
            }
            return params
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .getChatRoomDetail, .banChatMember, .deleteChatRoom, .getChatAdminMode, .deleteChatRoomByAdmin, .delegateToAdmin, .turnOnChatRoomAlarm, .turnOffChatRoomAlarm:
            request = URLRequest.createURLRequest(url: url, method: method)
        case .getPreviousChat:
            let queryDatas = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        case .getChatMembers:
            let queryDatas = queryParameters?.map { URLQueryItem(name: "ids", value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryDatas)
        }
        return request
    }
}
