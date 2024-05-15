import SwiftUI

// MARK: - PlaceholderColor

import SwiftUI

extension View {
    @ViewBuilder func placeholder(text: String, when shouldShow: Bool, alignment: Alignment = .leading) -> some View {
        if shouldShow {
            Text(text)
                .platformTextColor(color: Color("Gray03"))
                .frame(maxWidth: .infinity, alignment: alignment)
                .padding(.leading, 13)
                .font(.H4MediumFont())
        }
    }
}
