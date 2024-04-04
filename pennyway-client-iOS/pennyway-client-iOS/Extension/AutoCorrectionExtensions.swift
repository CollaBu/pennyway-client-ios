import SwiftUI

extension View {
    @ViewBuilder func AutoCorrectionExtensions() -> some View {
        if #available(iOS 15.0, *) {
            self.autocorrectionDisabled(true)
        } else {
            self.disableAutocorrection(true)
        }
    }
}


