
import Alamofire
import Foundation

class ApiRequstHandler {
    static let shared = ApiRequstHandler()

    func requestWithErrorHandling(session: Session, router: URLRequestConvertible, completion: @escaping (Result<Data?, Error>) -> Void) {
        session
            .request(router)
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = StatusCodeHandler.handleStatusCode(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = StatusSpecificError(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }

    func requestWithTokenHandling(session: Session, router: URLRequestConvertible, completion: @escaping (Result<Data?, Error>) -> Void) {
        session
            .request(router)
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case let .success(data):
                    TokenHandler.extractAndStoreToken(from: response)
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = StatusCodeHandler.handleStatusCode(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = StatusSpecificError(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}
