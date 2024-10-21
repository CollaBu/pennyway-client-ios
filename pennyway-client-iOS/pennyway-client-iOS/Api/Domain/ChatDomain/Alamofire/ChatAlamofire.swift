//
//  ChatAlamofire.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
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

    func getChatServer(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - getChatServer() called")

        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.getChatServer, completion: completion)
    }
}
