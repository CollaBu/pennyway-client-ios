//
//  ChatAlamofire.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/22/24.
//

import Alamofire
import Foundation

class ChatAlamofire {
    static let shared = ChatAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    /// 채팅방 생성
    func makeChatRoom(_ dto: MakeChatRoomRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - makeChatRoom() called \(dto)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.makeChatRoom(dto: dto), completion: completion)
    }
    
    func getChatServer(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - getChatServer() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.getChatServer, completion: completion)
    }
    
    /// 내 채팅 조회
    func getChatRoom(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - getChatRoom() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.getChatRoom, completion: completion)
    }
    
    /// 채팅방 검색
    func searchChatRoom(_ dto: SearchChatRoomRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - searchChatRoom() called")

        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.searchChatRoom(dto: dto), completion: completion)
    }
    
    /// 채팅방 가입
    func joinChatRoom(_ chatRoomId: Int64, _ dto: JoinChatRoomRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - joinChatRoom() called")

        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.joinChatRoom(chatRoomId: chatRoomId, dto: dto), completion: completion)
    }
}
