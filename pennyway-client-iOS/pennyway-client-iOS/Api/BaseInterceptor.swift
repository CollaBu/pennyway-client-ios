
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

        if let urlRequest = request.request {
            Log.info("[BaseInterceptor] retry Request URL: \(urlRequest.url?.absoluteString ?? "No URL")")
        }

        guard let response = request.task?.response as? HTTPURLResponse else {
            handleNetworkError(for: request, completion: completion) // netWork Error인 경우
            return
        }

        switch response.statusCode {
        case 401: // refresh 요청
            handleUnauthorized(for: request, completion: completion)
        case 400 ... 500:
            Log.error("Request failed with status code: \(response.statusCode). Not retrying.")
            completion(.doNotRetry)
        default:
            Log.error("[BaseInterceptor] Network error occurred")
        }
    }

    private func handleUnauthorized(for request: Request, completion: @escaping (RetryResult) -> Void) {
        TokenRefreshHandler.shared.refreshSync { result, shouldRetry in
            switch result {
            case .success:
                Log.debug("Token refreshed, retrying request: \(request)")
                completion(.retry)
            case .failure:
                if shouldRetry && request.retryCount < 1 {
                    Log.info("Retrying request due to failed token refresh")
                    completion(.retry)
                } else {
                    Log.info("Not retrying request after failed token refresh")
                    completion(.doNotRetry)
                }
            }
        }
    }

    private func handleNetworkError(for request: Request, completion: @escaping (RetryResult) -> Void) {
        Log.error("[BaseInterceptor] Network error occurred")
        if request.retryCount < 1 {
            Log.info("Retrying request once due to network error")
            completion(.retry)
        } else {
            Log.info("Not retrying after network error")
            completion(.doNotRetry)
        }
    }
}
