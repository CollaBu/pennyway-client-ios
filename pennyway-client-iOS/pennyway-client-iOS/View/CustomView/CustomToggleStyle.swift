import SwiftUI

// MARK: - CustomToggleStyle

struct CustomToggleStyle: ToggleStyle {
    @Binding var hasAppeared: Bool

    var onColor = Color("Mint03")
    var offColor = Color("Gray05")
    var thumbColor = Color("White01")

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 33 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 8 : -8))
                .animation(hasAppeared ? .easeInOut(duration: 0.3) : nil)
//                .animation(nil)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
