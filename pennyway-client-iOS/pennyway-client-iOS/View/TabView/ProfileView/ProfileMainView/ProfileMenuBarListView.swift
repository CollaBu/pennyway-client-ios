
import SwiftUI

// MARK: - ProfileMenuBarListView

struct ProfileMenuBarListView: View {
    @State private var showLogoutPopUp = false
    @State private var showDeleteUserPopUp = false
    @State private var showUnLinkPopUp = false
    @State private var showLinkErrorPopUp = false
    @State private var provider = ""
    @EnvironmentObject var authViewModel: AppViewModel
    @StateObject var userProfileViewModel = UserLogoutViewModel()
    @StateObject var userAccountViewModel = UserAccountViewModel()
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = .init()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = .init()
    @StateObject var appleOAuthViewModel: AppleOAuthViewModel = .init()

    @State private var navigateCompleteView = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ProfileOAuthButtonView(kakaoOAuthViewModel: kakaoOAuthViewModel, googleOAuthViewModel: googleOAuthViewModel, appleOAuthViewModel: appleOAuthViewModel, showUnLinkPopUp: $showUnLinkPopUp, provider: $provider)

                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                    ProfileSettingListView(showLogoutPopUp: $showLogoutPopUp, showDeleteUserPopUp: $showDeleteUserPopUp)
                }
                .background(Color("Gray01"))
            }
            .setTabBarVisibility(isHidden: true)
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

            if showUnLinkPopUp {
                CustomPopUpView(showingPopUp: $showUnLinkPopUp,
                                titleLabel: "계정 연동을 해제할까요?",
                                subTitleLabel: "해제하더라도 다시 연동할 수 있어요",
                                firstBtnAction: { self.showUnLinkPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: handleUnLinkAccount,
                                secondBtnLabel: "해제하기",
                                secondBtnColor: Color("Gray05"))
                    .analyzeEvent(ProfileEvents.oauthUnlinkPopUp)
            }

            if showLogoutPopUp {
                CustomPopUpView(showingPopUp: $showLogoutPopUp,
                                titleLabel: "로그아웃",
                                subTitleLabel: "로그아웃하시겠어요?",
                                firstBtnAction: { self.showLogoutPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: handleLogout,
                                secondBtnLabel: "로그아웃",
                                secondBtnColor: Color("Red03"))
                    .analyzeEvent(ProfileEvents.signOutPopUp)
            }

            if showDeleteUserPopUp {
                CustomPopUpView(showingPopUp: $showDeleteUserPopUp,
                                titleLabel: "탈퇴하시겠어요?",
                                subTitleLabel: "탈퇴 후에는 이용한 서비스\n내역이 모두 사라져요 😢",
                                firstBtnAction: handleDeleteUserAccount,
                                firstBtnLabel: "탈퇴하기",
                                secondBtnAction: { self.showDeleteUserPopUp = false },
                                secondBtnLabel: "더 써볼게요",
                                secondBtnColor: Color("Gray05"),
                                heightSize: 166)
                    .analyzeEvent(ProfileEvents.accountDeletePopUp)
            }

            if googleOAuthViewModel.isExistUser || kakaoOAuthViewModel.isExistUser || appleOAuthViewModel.isExistUser {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)

                ErrorCodePopUpView(showingPopUp: $googleOAuthViewModel.isExistUser, titleLabel: "계정이 이미 연동되어 있어요", subLabel: "이미 연동된 계정은 사용할 수 없어요")
            }

            NavigationLink(destination: CompleteDeleteUserView(), isActive: $navigateCompleteView) {
                EmptyView()
            }
            .hidden()
        }
        .analyzeEvent(ProfileEvents.profileHamburgerMenuTap)
        .onChange(of: ProfileMenuPopUpState(showLogoutPopUp: showLogoutPopUp, showDeleteUserPopUp: showDeleteUserPopUp, showUnLinkPopUp: showUnLinkPopUp)) { state in
            if state.isReturn() {
                AnalyticsManager.shared.trackEvent(ProfileEvents.profileHamburgerMenuTap, additionalParams: nil)
            }
        }
    }

    func handleLogout() {
        if let fcmToken = AppDelegate.currentFCMToken {
            userProfileViewModel.deleteDeviceTokenApi(fcmToken: fcmToken) { success in
                DispatchQueue.main.async {
                    if success {
                        self.showLogoutPopUp = false
                        self.authViewModel.logout()
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

    func handleUnLinkAccount() {
        switch provider {
        case "kakao":
            kakaoOAuthViewModel.signIn()
        case "google":
            googleOAuthViewModel.signIn()
        case "apple":
            appleOAuthViewModel.signIn()
        default:
            Log.debug("계정 연동 해제 실패")
        }
        showUnLinkPopUp = false
    }
}

// MARK: - ProfileMenuPopUpState

struct ProfileMenuPopUpState: Equatable {
    var showLogoutPopUp: Bool
    var showDeleteUserPopUp: Bool
    var showUnLinkPopUp: Bool

    func isReturn() -> Bool {
        return !showLogoutPopUp && !showDeleteUserPopUp && !showUnLinkPopUp
    }
}

#Preview {
    ProfileMenuBarListView()
}
