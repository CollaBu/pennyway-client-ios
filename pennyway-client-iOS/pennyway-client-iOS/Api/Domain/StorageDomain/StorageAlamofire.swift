
import Alamofire
import Foundation

class StorageAlamofire {
    static let shared = StorageAlamofire()

    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session

    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }

    func generatePresignedUrl(_ dto: GeneratePresigendUrlRequeatDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("StorageAlamofire - generatePresignedUrl() called")

        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: StorageRouter.generatePresignedUrl(dto: dto), completion: completion)
    }
}
