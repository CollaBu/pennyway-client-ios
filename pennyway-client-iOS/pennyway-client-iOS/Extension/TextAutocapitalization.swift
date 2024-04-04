import SwiftUI

extension View {
    @ViewBuilder func TextAutocapitalization() -> some View {
        if #available(iOS 15.0, *) {
            self.textInputAutocapitalization(.never)
        } else {
            self.autocapitalization(.none)
        }
    }
}

