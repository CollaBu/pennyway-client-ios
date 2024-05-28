
import SwiftUI

struct ProfileMenuBarListView: View {
    @State private var showingPopUp = false
    @EnvironmentObject var authViewModel: AppViewModel
    @StateObject var userProfileViewModel = UserLogoutViewModel()

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ProfileOAuthButtonView()

                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                    ProfileSettingListView(showingPopUp: $showingPopUp)
                }
                .background(Color("Gray01"))
            }
            //        .edgesIgnoringSafeArea(.bottom)
            .setTabBarVisibility(isHidden: false)
            .navigationBarColor(UIColor(named: "White01"), title: "")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())

                    }.offset(x: -10)
                }
            }

            if showingPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingPopUp,
                                titleLabel: "로그아웃",
                                subTitleLabel: "로그아웃하시겠어요?",
                                firstBtnAction: { self.showingPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: handleLogout,
                                secondBtnLabel: "로그아웃",
                                secondBtnColor: Color("Red03")
                )
            }
        }
    }

    func handleLogout() {
        userProfileViewModel.logout { success in
            DispatchQueue.main.async {
                if success {
                    authViewModel.logout()
                    showingPopUp = false
                } else {
                    Log.error("Fail logout")
                }
            }
        }
    }
}

#Preview {
    ProfileMenuBarListView()
}
