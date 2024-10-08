//
//  KeyboardHandler.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import Combine
import SwiftUI

// MARK: - KeyboardHandler

class KeyboardHandler: ObservableObject {
    @Published private(set) var keyboardHeight: CGFloat = 0

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { $0.height }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat.zero }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}
