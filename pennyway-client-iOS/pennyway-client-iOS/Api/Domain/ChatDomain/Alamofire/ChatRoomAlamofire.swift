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
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.getChatRoomDetail, completion: completion)
    }
}
