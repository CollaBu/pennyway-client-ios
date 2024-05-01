
import SwiftUI

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("지출관리")
                }
                .tag(0)
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("피드")
                }
                .tag(1)
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("채팅")
                }
                .tag(2)
            ProfileMainView()
                .tabItem {
                    selection == 3 ? Image("icon_tapbar_profile_on") : Image("icon_tapbar_profile_off")
                    Text("프로필")
                }
                .tag(3)
        }
        .accentColor(Color("Mint03"))
        .onAppear {
            UITabBar.appearance().barTintColor = .white
        }
    }
}

#Preview {
    MainTabView()
}
