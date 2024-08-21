import Combine
import SwiftUI

class NetworkStatusViewModel: ObservableObject {
    @Published var showToast: Bool = false

    private var lastConnectionStatus: Bool = true
    private var cancellable: AnyCancellable?

    init() {
        cancellable = NotificationCenter.default
            .publisher(for: .changeNetworkState)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.changeNetworkState()
            }
    }

    private func changeNetworkState() {
        let currentStatus = NetworkMonitor.shared.isConnected

        if !currentStatus {
            showToast = true
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
