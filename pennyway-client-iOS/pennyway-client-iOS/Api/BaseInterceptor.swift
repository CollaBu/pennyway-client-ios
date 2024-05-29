
import Alamofire
import Foundation

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
            AuthAlamofire.shared.refresh { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                            Log.debug(response)

                            completion(.retry)

                        } catch {
                            Log.fault("Error parsing response JSON: \(error)")
                            completion(.doNotRetry)
                        }
                    }
                case let .failure(error):
                    if let statusSpecificError = error as? StatusSpecificError {
                        Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                    } else {
                        Log.error("Network request failed: \(error)")
                    }
                    completion(.doNotRetry)
                }
            }
        } else {}
    }
}
