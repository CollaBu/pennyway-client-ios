
import Alamofire
import Foundation

class ApiRequstHandler: TokenHandler {
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
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = DomainSpecificError(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
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
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = DomainSpecificError(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}
