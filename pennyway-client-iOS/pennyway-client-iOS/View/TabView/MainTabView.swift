
import SwiftUI

struct MainTabView: View {
    @State private var selection = 0
    @EnvironmentObject var authViewModel: AppViewModel

    var body: some View {
        TabView(selection: $selection) {
            NavigationAvailable {
                SpendingManagementMainView()
            }
            .tabItem {
                selection == 0 ? Image("icon_tabbar_expenditure_on") : Image("icon_tabbar_expenditure_off")
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
                    selection == 3 ? Image("icon_tabbar_profile_on") : Image("icon_tabbar_profile_off")
                    Text("프로필")
                }
                .tag(3)
        }
//        .navigationBarBackButtonHidden(true)
        .accentColor(Color("Mint03"))
        .onAppear {
            UITabBar.appearance().barTintColor = .white
        }
    }
}

#Preview {
    MainTabView()
}
