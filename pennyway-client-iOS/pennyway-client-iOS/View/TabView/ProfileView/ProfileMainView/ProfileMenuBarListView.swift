
import SwiftUI

struct ProfileMenuBarListView: View {
    @State private var showLogoutPopUp = false
    @State private var showDeleteUserPopUp = false
    @EnvironmentObject var authViewModel: AppViewModel
    @StateObject var userProfileViewModel = UserLogoutViewModel()
    @StateObject var userAccountViewModel = UserAccountViewModel()

    @State private var navigateCompleteView = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ProfileOAuthButtonView()

                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                    ProfileSettingListView(showLogoutPopUp: $showLogoutPopUp, showDeleteUserPopUp: $showDeleteUserPopUp)
                }
                .background(Color("Gray01"))
            }
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

            if showLogoutPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showLogoutPopUp,
                                titleLabel: "로그아웃",
                                subTitleLabel: "로그아웃하시겠어요?",
                                firstBtnAction: { self.showLogoutPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: handleLogout,
                                secondBtnLabel: "로그아웃",
                                secondBtnColor: Color("Red03")
                )
            }

            if showDeleteUserPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showLogoutPopUp,
                                titleLabel: "탈퇴하시겠어요?",
                                subTitleLabel: "탈퇴 후에는 이용한 서비스\n내역이 모두 사라져요 😢",
                                firstBtnAction: handleDeleteUserAccount,
                                firstBtnLabel: "탈퇴하기",
                                secondBtnAction: { self.showDeleteUserPopUp = false },
                                secondBtnLabel: "더 써볼게요",
                                secondBtnColor: Color("Gray05"),
                                heightSize: 166
                )
            }

            NavigationLink(destination: CompleteDeleteUserView(), isActive: $navigateCompleteView) {
                EmptyView()
            }
            .hidden()
        }
    }

    func handleLogout() {
        if let fcmToken = AppDelegate.currentFCMToken {
            userProfileViewModel.deleteDeviceTokenApi(fcmToken: fcmToken) { success in
                DispatchQueue.main.async {
                    if success {
                        Log.debug("디바이스 토큰 삭제 성공")
                        userProfileViewModel.logout { success in
                            if success {
//                                authViewModel.logout()
                                showLogoutPopUp = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    authViewModel.logout()
                                }
                                Log.debug("로그아웃 성공")
                            } else {
                                Log.error("로그아웃 실패")
                            }
                        }
                    } else {
                        Log.error("디바이스 토큰 삭제 실패")
                    }
                }
            }
        }
    }

    func handleDeleteUserAccount() {
        userAccountViewModel.deleteUserAccountApi { success in
            DispatchQueue.main.async {
                if success {
                    showDeleteUserPopUp = false
                    navigateCompleteView = true
                } else {
                    Log.error("Fail delete UserAccount")
                }
            }
        }
    }
}

#Preview {
    ProfileMenuBarListView()
}
