
import SwiftUI

// MARK: - DiffAmountDynamicWidthView

struct DiffAmountDynamicWidthView: View {
    var text: String
    var backgroundColor: Color
    var textColor: Color

    @State private var textWidth: CGFloat = .zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: textWidth, height: 24 * DynamicSizeFactor.factor())
                .platformTextColor(color: backgroundColor)
            
            Text(text)
                .platformTextColor(color: textColor)
                .font(.B2SemiboldFont())
                .padding(.horizontal, 10)
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: TextWidthPreferenceKey.self, value: geometry.size.width)
                })
        }
        .onPreferenceChange(TextWidthPreferenceKey.self) { width in
            self.textWidth = width
        }
    }
}

// MARK: - TextWidthPreferenceKey

struct TextWidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
