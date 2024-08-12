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
    private var pendingRequests: [(Result<Data?, Error>) -> Void] = []
    
    private init() {}
    
    func refreshSync(completion: @escaping (Result<Data?, Error>) -> Void) {
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
                        self.notifyPendingRequests(result: .failure(error))
                        completion(.failure(error))
                    }
                }
                        
                self.notifyPendingRequests(result: .success(data))
                completion(.success(data))
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                
                self.notifyPendingRequests(result: .failure(error))
                completion(.failure(error))
            }
                    
            self.isRefreshing = false
        }
    }
    
    private func notifyPendingRequests(result: Result<Data?, Error>) {
        pendingRequests.forEach { $0(result) }
        pendingRequests.removeAll()
    }
}
