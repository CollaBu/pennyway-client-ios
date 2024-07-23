
import SwiftUI

struct LoadingView: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Color("Mint03"))
                .frame(width: 5, height: 5)
                .offset(y: animate ? -10 : 10)

                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate)
            Circle()
                .fill(Color("Mint03"))
                .frame(width: 5, height: 5)
                .offset(y: animate ? -10 : 10)

                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(0.2), value: animate)
            Circle()
                .fill(Color("Mint03"))
                .frame(width: 5, height: 5)
                .offset(y: animate ? -10 : 10)

                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(0.4), value: animate)
        }
        .onAppear {
            animate = true
        }
    }
}
