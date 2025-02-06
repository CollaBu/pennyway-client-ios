import SwiftUI

// MARK: - MainTabView

struct MainTabView: View {
    @StateObject private var viewModel = MainTabViewModel()
    @EnvironmentObject var authViewModel: AppViewModel
    @EnvironmentObject var networkStatus: NetworkStatusViewModel
    @EnvironmentObject var deepLinkCoordinator: DeepLinkCoordinator
    @StateObject private var navigationState = ChatNavigationState.shared

    var body: some View {
        TabView(selection: $viewModel.selection) {
            SpendingManagementMainView()
                .id(viewModel.spendingViewId)
                .tabItem {
                    viewModel.selection == 0 ? Image("icon_tabbar_expenditure_on") : Image("icon_tabbar_expenditure_off")
                    Text("지출관리")
                }
                .tag(0)
                .buttonStyle(BasicButtonStyleUtil())

            PreparedView()
                .tabItem {
                    viewModel.selection == 1 ? Image("icon_tapbar_feed_on") : Image("icon_tapbar_feed_off")
                    Text("피드")
                }
                .tag(1)
                .buttonStyle(BasicButtonStyleUtil())

            LazyView {
                AppComponent()
                    .makeChatRootView()
            }
            .tabItem {
                viewModel.selection == 2 ? Image("icon_tapbar_chatting_on") : Image("icon_tapbar_chatting_off")
                Text("채팅")
            }
            .tag(2)
            .buttonStyle(BasicButtonStyleUtil())

            LazyView {
                AppComponent()
                    .makeProfileRootView()
            }
            .tabItem {
                viewModel.selection == 3 ? Image("icon_tabbar_profile_on") : Image("icon_tabbar_profile_off")
                Text("프로필")
            }
            .tag(3)
            .buttonStyle(BasicButtonStyleUtil())
        }
        .environmentObject(viewModel)
        .accentColor(Color("Mint03"))
        .onAppear {
            UITabBar.appearance().barTintColor = .white
        }
        .onChange(of: navigationState.shouldNavigateToChatRoom) { showNavigate in
            if showNavigate {
                // 딥링크를 통해 채팅 탭으로 이동
                viewModel.selection = 2

                Log.debug("[MainTabView]: \(String(describing: navigationState.selectedChatRoomId))")

                DispatchQueue.main.async {
                    navigationState.shouldNavigateToChatRoom = false
                }
            }
        }
    }
}

// MARK: - MainTabViewModel

class MainTabViewModel: ObservableObject {
    @Published var selection: Int = 0
    @Published var spendingViewId: UUID = UUID() // 초기화 트리거용 ID

    /// 🚀 SpendingManagementMainView를 초기화하고 탭 이동
    func resetSpendingViewAndSwitchToChat() {
        spendingViewId = UUID() // 새로운 UUID를 할당하여 초기화
        selection = 2 // 채팅 탭으로 변경
    }
}
