
import Foundation
import SwiftUI

struct BasicButtonStyleUtil: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.3 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
