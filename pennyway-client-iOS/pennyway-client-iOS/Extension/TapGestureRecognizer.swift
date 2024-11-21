import SwiftUI

extension UIApplication {
    static var shouldDismissKeyboard: Bool = true

    func addTapGestureRecognizer() {
        guard let window = windows.first else {
            return
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapGesture(_: UITapGestureRecognizer) {
        guard let window = windows.first else {
            return
        }

        if UIApplication.shouldDismissKeyboard {
            window.endEditing(true) // 키보드 닫기
        }
    }
}

// MARK: - UIApplication + UIGestureRecognizerDelegate

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
