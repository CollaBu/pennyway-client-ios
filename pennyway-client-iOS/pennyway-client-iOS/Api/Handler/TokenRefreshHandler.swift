//
//  TokenRefreshHandler.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/11/24.
//

import Foundation

class TokenRefreshHandler {
    static let shared = TokenRefreshHandler()
    private var isRefreshing = false
    private var pendingRequests: [(Result<Data?, Error>, Bool) -> Void] = []
    
    private init() {}
    
    func refreshSync(completion: @escaping (Result<Data?, Error>, Bool) -> Void) {
        Log.debug("TokenRefreshManager - refreshSync() called - isRefreshing: \(isRefreshing)")
        
        if isRefreshing {
            pendingRequests.append(completion)
            Log.debug("TokenRefreshManager - request pending")
            return
        }
                
        isRefreshing = true
                
        AuthAlamofire.shared.refresh { [weak self] result in
            guard let self = self else {
                return
            }
                    
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug(response)
                        
                        AnalyticsManager.shared.setUser("userId = \(response.data.user.id)")
                        AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                            AnalyticsConstants.Parameter.oauthType: "none",
                            AnalyticsConstants.Parameter.isRefresh: true
                        ])
                        
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        self.notifyPendingRequests(result: .failure(error), shouldRetry: false)
                        completion(.failure(error), false)
                    }
                }
                self.notifyPendingRequests(result: .success(data), shouldRetry: false)
                completion(.success(data), false)
                
            case let .failure(error):
                var shouldRetry = false
                
                if let statusSpecificError = error as? StatusSpecificError {
                    if statusSpecificError.domainError == .unauthorized, statusSpecificError.code == UnauthorizedErrorCode.expiredOrRevokedToken.rawValue || statusSpecificError.domainError == .forbidden, statusSpecificError.code == ForbiddenErrorCode.accessForbidden.rawValue {
                        // 401, 403 에러인 경우 로그아웃
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .logoutNotification, object: nil)
                        }
                    }
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failedd: \(error)")
                    // 네트워크 오류 발생 시 재시도 플래그 설정
                    shouldRetry = true
                }
                
                self.notifyPendingRequests(result: .failure(error), shouldRetry: shouldRetry)
                completion(.failure(error), shouldRetry)
            }
            
            self.isRefreshing = false
        }
    }
    
    private func notifyPendingRequests(result: Result<Data?, Error>, shouldRetry: Bool) {
        pendingRequests.forEach { $0(result, shouldRetry) }
        pendingRequests.removeAll()
    }
}
