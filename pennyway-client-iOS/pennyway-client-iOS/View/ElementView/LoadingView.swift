
import SwiftUI

struct LoadingView: View {
    @State private var animate = false
    @Binding var startAnimate: Bool
    private let frameFactor = 5 * DynamicSizeFactor.factor()
    private let offsetFactor = 3 * DynamicSizeFactor.factor()

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Color("Mint03"))
                .frame(width: frameFactor, height: frameFactor)
                .offset(y: animate ? -offsetFactor : offsetFactor)
                .animation(animate ? Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: animate)
            Circle()
                .fill(Color("Mint03"))
                .frame(width: frameFactor, height: frameFactor)
                .offset(y: animate ? -offsetFactor : offsetFactor)
                .animation(animate ? Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(0.2) : .default, value: animate)
            Circle()
                .fill(Color("Mint03"))
                .frame(width: frameFactor, height: frameFactor)
                .offset(y: animate ? -offsetFactor : offsetFactor)
                .animation(animate ? Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(0.4) : .default, value: animate)
        }
        .onAppear {
            animate = true
        }
        .onChange(of: startAnimate) { value in
            if !value {
                animate = false
            }
        }
    }
}
