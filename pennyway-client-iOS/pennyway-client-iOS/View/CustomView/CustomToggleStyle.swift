import SwiftUI

// MARK: - ToggleSize

enum ToggleSize {
    case small
    case large

    var width: CGFloat {
        switch self {
        case .small: return 23
        case .large: return 33
        }
    }

    var height: CGFloat {
        switch self {
        case .small: return 14
        case .large: return 20
        }
    }

    var thumbOffset: CGFloat {
        switch self {
        case .small: return 6
        case .large: return 8
        }
    }

    var padding: CGFloat {
        switch self {
        case .small: return 1
        case .large: return 1.5
        }
    }
}

// MARK: - CustomToggleStyle

struct CustomToggleStyle: ToggleStyle {
    @Binding var hasAppeared: Bool
    var size: ToggleSize

    var onColor = Color("Mint03")
    var offColor = Color("Gray05")
    var thumbColor = Color("White01")

    init(hasAppeared: Binding<Bool>, size: ToggleSize = .large) {
        _hasAppeared = hasAppeared
        self.size = size
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(
                    width: size.width * DynamicSizeFactor.factor(),
                    height: size.height * DynamicSizeFactor.factor()
                )
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(size.padding)
                        .offset(x: configuration.isOn ? size.thumbOffset : -size.thumbOffset))
                .animation(hasAppeared ? .easeInOut(duration: 0.3) : nil)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
