//
//  ChatRoomAlamofire.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Alamofire

class ChatRoomAlamofire {
    static let shared = ChatRoomAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    /// 채팅방 생성
    func getChatRoomDetail(_ chatRoomId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - getChatRoomDetail() called \(chatRoomId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.getChatRoomDetail(chatRoomId: chatRoomId), completion: completion)
    }
    
    /// 채팅 이력 조회
    func getChatData(_ chatRoomId: Int64, _ lastMessageId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - getChatData() called \(chatRoomId) \(lastMessageId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.getChatData(chatRoomId: chatRoomId, lastMessageId: lastMessageId), completion: completion)
    }
}
