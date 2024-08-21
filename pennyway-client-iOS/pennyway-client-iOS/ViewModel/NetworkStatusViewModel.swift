
import Combine
import SwiftUI

class NetworkStatusViewModel: ObservableObject {
    @Published var isConnected: Bool = NetworkMonitor.shared.isConnected
    @Published var showToast: Bool = false

    private var lastConnectionStatus: Bool = true

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .networkStatusChanged, object: nil)
    }

    @objc private func networkStatusChanged(_: Notification) {
        DispatchQueue.main.async {
            let currentStatus = NetworkMonitor.shared.isConnected
//            self.isConnected = currentStatus

            if !currentStatus {
                self.showToast = true

                Log.debug("??: 네트워크 오류")

                // 일정 시간 후에 토스트를 숨김
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showToast = false
                }
            }
        }
    }
}
