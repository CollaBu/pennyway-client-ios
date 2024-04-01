
import Alamofire
import Foundation
import os.log

class AdminAlamofire: TokenHandling {
    // MARK: Lifecycle

    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }

    // MARK: Internal

    static let shared = AdminAlamofire()

    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])

    var session: Session

    func regist(_ username: String, _ name: String, _ password: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AdminAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ", log: .default, type: .info, username, password, name)

        session
            .request(AdminRouter.regist(username: username, name: name, password: password))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
