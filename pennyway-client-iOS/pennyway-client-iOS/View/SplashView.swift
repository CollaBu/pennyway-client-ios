
import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("primary")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("logo_pennyway")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100) 
            }
        }
    }
}




