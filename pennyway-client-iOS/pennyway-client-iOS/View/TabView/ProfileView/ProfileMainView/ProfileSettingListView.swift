import os.log
import SwiftUI

// MARK: - ProfileSettingListView

struct ProfileSettingListView: View {
    @EnvironmentObject var authViewModel: AppViewModel
    @Binding var showingPopUp: Bool
    @StateObject var userAccountViewModel = UserAccountViewModel()
    ///    @State private var showingPopUp = false
    @State private var isNavigateToInquiryView = false
    @State private var isNavigateToSettingAlarmView = false

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 32 * DynamicSizeFactor.factor())

                LazyVStack(spacing: 0) {
                    ProfileSettingSectionView(showingPopUp: $showingPopUp, title: "내 정보", itemsWithActions: [
                        ProfileSettingListItem(title: "내 정보 수정", icon: "icon_modifyingprofile", action: {}),
                        ProfileSettingListItem(title: "내가 쓴 글", icon: "icon_list", action: {}),
                        ProfileSettingListItem(title: "스크랩", icon: "icon_scrap", action: {}),
                        ProfileSettingListItem(title: "비밀번호 변경", icon: "icon_change password", action: {})
                    ])

                    Divider()
                        .frame(width: 301 * DynamicSizeFactor.factor(), height: 0.43)
                        .overlay(Color("Gray02"))

                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                    ProfileSettingSectionView(showingPopUp: $showingPopUp, title: "앱 설정", itemsWithActions: [
                        ProfileSettingListItem(title: "알림 설정", icon: "icon_notificationsetting", action: { isNavigateToSettingAlarmView = true })
                    ])

                    Divider()
                        .frame(width: 301 * DynamicSizeFactor.factor(), height: 0.43)
                        .overlay(Color("Gray02"))

                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                    ProfileSettingSectionView(showingPopUp: $showingPopUp, title: "이용안내", itemsWithActions: [
                        ProfileSettingListItem(title: "문의하기", icon: "icon_checkwithsomeone", action: {
                            isNavigateToInquiryView = true
                        })
                    ])

                    Divider()
                        .frame(width: 301 * DynamicSizeFactor.factor(), height: 0.43)
                        .overlay(Color("Gray02"))

                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                    ProfileSettingSectionView(showingPopUp: $showingPopUp, title: "기타", itemsWithActions: [
                        ProfileSettingListItem(title: "로그아웃", icon: "icon_logout", action: { self.showingPopUp = true }),
                        ProfileSettingListItem(title: "회원탈퇴", icon: "icon_cancelmembership", action: handleDeleteUserAccount)
                    ])
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("White01"))

            NavigationLink(destination: InquiryView(viewModel: InquiryViewModel()), isActive: $isNavigateToInquiryView) {
                EmptyView()
            }.hidden()

            NavigationLink(destination: SettingAlarmView(), isActive: $isNavigateToSettingAlarmView) {
                EmptyView()
            }.hidden()
        }
        .setTabBarVisibility(isHidden: true)
        .navigationBarColor(UIColor(named: "White01"), title: "")
    }

    func handleDeleteUserAccount() {
        userAccountViewModel.deleteUserAccountApi { success in
            DispatchQueue.main.async {
                if success {
                    authViewModel.logout()
                } else {
                    Log.error("Fail delete UserAccount")
                }
            }
        }
    }
}

// MARK: - MenuItem

struct MenuItem {
    let title: String
    let icon: String
    let action: () -> Void
}

// MARK: - ProfileSettingSectionView

struct ProfileSettingSectionView: View {
    @Binding var showingPopUp: Bool

    let title: String

    let itemsWithActions: [ProfileSettingListItem] // ProfileSettingListItem 배열로 변경

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.B2SemiboldFont())
                .platformTextColor(color: Color("Gray04"))
                .background(Color(UIColor.systemBackground))
                .padding(.horizontal, 21)

            Spacer().frame(height: 14 * DynamicSizeFactor.factor())

            ForEach(itemsWithActions, id: \.title) { item in // itemsWithActions 배열 순회
                Button(action: {
                    item.action() // 항목별 액션 실행
                }, label: {
                    HStack {
                        Image(item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32 * DynamicSizeFactor.factor(), height: 32 * DynamicSizeFactor.factor(), alignment: .leading)

                        Text(item.title)
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.vertical, 7)
                    }
                })
                .padding(.horizontal, 17)
            }
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
