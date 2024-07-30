
import SwiftUI

// MARK: - MainTabView

struct MainTabView: View {
    @State private var selection = 0
    @EnvironmentObject var authViewModel: AppViewModel

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                SpendingManagementMainView()
                    .tabItem {
                        selection == 0 ? Image("icon_tabbar_expenditure_on") : Image("icon_tabbar_expenditure_off")
                        Text("지출관리")
                    }
                    .tag(0)

                PreparedFeedView()
                    .tabItem {
                        selection == 1 ? Image("icon_tapbar_feed_on") : Image("icon_tapbar_feed_off")
                        Text("피드")
                    }
                    .tag(1)

                PreparedChatView()
                    .tabItem {
                        selection == 2 ? Image("icon_tapbar_chatting_on") : Image("icon_tapbar_chatting_off")
                        Text("채팅")
                    }
                    .tag(2)

                ProfileMainView()

                    .tabItem {
                        selection == 3 ? Image("icon_tabbar_profile_on") : Image("icon_tabbar_profile_off")
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
}

#Preview {
    MainTabView()
}
