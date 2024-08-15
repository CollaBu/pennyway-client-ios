
import Alamofire
import Foundation

class BaseInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        Log.info("BaseInterceptor - adapt()")

        var adaptedRequest = urlRequest

        guard let accessToken = KeychainHelper.loadAccessToken(), !accessToken.isEmpty else {
            Log.error("[BaseInterceptor]: Access token이 존재하지 않음")
            completion(.failure(NSError(domain: "", code: 499, userInfo: [NSLocalizedDescriptionKey: "Missing Access Token"])))
            return
        }

        adaptedRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")

        if let url = adaptedRequest.url, let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            adaptedRequest.allHTTPHeaderFields = cookieHeader
        }

        completion(.success(adaptedRequest))
    }

    func retry(_ request: Request, for _: Session, dueTo _: Error, completion: @escaping (RetryResult) -> Void) {
        Log.info("BaseInterceptor - retry()")

        if let response = request.task?.response as? HTTPURLResponse {
            Log.debug(response.statusCode)
        }

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            TokenRefreshHandler.shared.refreshSync { result in
                switch result {
                case .success:
                    Log.debug("Token refreshed, retrying request : \(request)")
                    completion(.retry)
                case .failure:
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
