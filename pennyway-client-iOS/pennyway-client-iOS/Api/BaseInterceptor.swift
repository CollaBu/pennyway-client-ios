
import Alamofire
import Foundation

// MARK: - BaseInterceptor

class BaseInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        Log.info("BaseInterceptor - adapt()")

        var adaptedRequest = urlRequest
        let accessToken = KeychainHelper.loadAccessToken()
        adaptedRequest.setValue("Bearer " + (accessToken ?? ""), forHTTPHeaderField: "Authorization")

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
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .logoutNotification, object: nil)
                    }
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
