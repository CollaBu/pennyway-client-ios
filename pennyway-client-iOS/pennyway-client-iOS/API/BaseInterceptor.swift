
import Alamofire
import Foundation

class BaseInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() ")

        var adaptedRequest = urlRequest
        let accessToken = KeychainHelper.loadAccessToken()!
        adaptedRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")

        if let url = adaptedRequest.url, let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            adaptedRequest.allHTTPHeaderFields = cookieHeader
        }

        completion(.success(adaptedRequest))
    }

    func retry(_ request: Request, for _: Session, dueTo _: Error, completion _: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry()")

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
        } else {}
    }
}
