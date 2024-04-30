
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("지출관리")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("피드")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("채팅")
                }
            ProfileMainView()
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("프로필")
                }
        }
        .accentColor(Color("Mint03"))
       
    }
}

#Preview {
    MainTabView()
}
