import SwiftUI

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
                .frame(width: 50, height: 29)
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(.easeInOut(duration: 0.3))
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
