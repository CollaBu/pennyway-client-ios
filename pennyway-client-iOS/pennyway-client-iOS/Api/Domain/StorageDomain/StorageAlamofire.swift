
import Alamofire
import Foundation

class StorageAlamofire {
    static let shared = StorageAlamofire()

    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var generateSession: Session
    var storeSession: Session

    private init() {
        generateSession = Session(interceptor: interceptors, eventMonitors: monitors)
        storeSession = Session(eventMonitors: monitors)
    }

    func generatePresignedUrl(_ dto: GeneratePresigendUrlRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("StorageAlamofire - generatePresignedUrl() called")

        ApiRequstHandler.shared.requestWithErrorHandling(session: generateSession, router: StorageRouter.generatePresignedUrl(dto: dto), completion: completion)
    }

    func storePresignedUrl(_ payload: String, _ image: UIImage, _ dto: StorePresignedUrlRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("StorageAlamofire - storePresignedUrl() called")

        ApiRequstHandler.shared.requestWithErrorHandling(session: storeSession, router: StorageRouter.storePresignedUrl(payload: payload, image: image, dto: dto), completion: completion)
    }
}
