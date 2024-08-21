import Combine
import SwiftUI

class NetworkStatusViewModel: ObservableObject {
    @Published var showToast: Bool = false
    @Published var paddingValue: CGFloat = 34

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

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showToast = false
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
