

import SwiftUI

extension View {
    @ViewBuilder func platformTextColor(color: Color) -> some View{
        if #available(iOS 15.0, *) {
            self.foregroundStyle(color)
        } else {
            self.foregroundColor(color)
        }
    }
}
