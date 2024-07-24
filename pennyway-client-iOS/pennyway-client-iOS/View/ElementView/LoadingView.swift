
import SwiftUI

struct LoadingView: View {
    @State private var animate = false

    private let frameFactor = 5 * DynamicSizeFactor.factor()
    private let offsetFactor = 3 * DynamicSizeFactor.factor()

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Color("Mint03"))
                .frame(width: frameFactor, height: frameFactor)
                .offset(y: animate ? -offsetFactor : offsetFactor)

                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate)
            Circle()
                .fill(Color("Mint03"))
                .frame(width: frameFactor, height: frameFactor)
                .offset(y: animate ? -offsetFactor : offsetFactor)

                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(0.2), value: animate)
            Circle()
                .fill(Color("Mint03"))
                .frame(width: frameFactor, height: frameFactor)
                .offset(y: animate ? -offsetFactor : offsetFactor)

                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(0.4), value: animate)
        }
        .onAppear {
            animate = true
        }
    }
}
