
import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("Mint03")
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("icon_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 112, height: 112)
            }
        }
    }
}
