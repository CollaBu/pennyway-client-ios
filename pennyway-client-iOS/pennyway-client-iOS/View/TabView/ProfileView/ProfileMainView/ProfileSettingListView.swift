import os.log
import SwiftUI

// MARK: - ProfileSettingListView

struct ProfileSettingListView: View {
    @Binding var showLogoutPopUp: Bool
    @Binding var showDeleteUserPopUp: Bool
    @State private var activeNavigation: ProfileActiveNavigation?

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 32 * DynamicSizeFactor.factor())

                LazyVStack(spacing: 0) {
                    ProfileSettingSectionView(title: "내 정보", itemsWithActions: [
                        ProfileSettingListItem(title: "내 정보 수정", icon: "icon_modifyingprofile", action: {
                            activeNavigation = .editProfile
                        }),
                        ProfileSettingListItem(title: "스크랩", icon: "icon_scrap", action: {}),
                        ProfileSettingListItem(title: "비밀번호 변경", icon: "icon_change password", action: {
//                            activeNavigation = .modifyPw
                            NavigationUtil.popToRootView()
                        })
                    ])

                    Divider()
                        .overlay(Color("Gray02"))
                        .frame(width: 301 * DynamicSizeFactor.factor(), height: 0.43)

                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                    ProfileSettingSectionView(title: "앱 설정", itemsWithActions: [
                        ProfileSettingListItem(title: "알림 설정", icon: "icon_notificationsetting", action: { activeNavigation = .settingAlarm })
                    ])

                    Divider()
                        .overlay(Color("Gray02"))
                        .frame(width: 301 * DynamicSizeFactor.factor(), height: 0.43)

                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                    ProfileSettingSectionView(title: "이용안내", itemsWithActions: [
                        ProfileSettingListItem(title: "문의하기", icon: "icon_checkwithsomeone", action: {
                            activeNavigation = .inquiry
                        })
                    ])

                    Divider()
                        .overlay(Color("Gray02"))
                        .frame(width: 301 * DynamicSizeFactor.factor(), height: 0.43)

                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                    ProfileSettingSectionView(title: "기타", itemsWithActions: [
                        ProfileSettingListItem(title: "로그아웃", icon: "icon_logout", action: { self.showLogoutPopUp = true }),
                        ProfileSettingListItem(title: "회원탈퇴", icon: "icon_cancelmembership", action: { self.showDeleteUserPopUp = true })
                    ])
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("White01"))

            navigationLinks
        }
    }

    @ViewBuilder
    private var navigationLinks: some View {
        ForEach(ProfileActiveNavigation.allCases, id: \.self) { destination in
            NavigationLink(destination: destinationView(for: destination), tag: destination, selection: $activeNavigation) {
                EmptyView()
            }
            .hidden()
        }
    }

    /// 이동할 뷰 정리
    @ViewBuilder
    private func destinationView(for destination: ProfileActiveNavigation) -> some View {
        switch destination {
        case .inquiry:
            InquiryView(viewModel: InquiryViewModel())
        case .settingAlarm:
            SettingAlarmView()
        case .editProfile:
            EditProfileListView()
        case .modifyPw:
            ProfileModifyPwView(entryPoint: .modifyPw)
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
                    HStack(spacing: 13) { // 동적 ui 적용하니까 너무 간격 넓음
                        Image(item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32 * DynamicSizeFactor.factor(), height: 32 * DynamicSizeFactor.factor(), alignment: .leading)

                        Text(item.title)
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.vertical, 7)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                })
                .padding(.horizontal, 17)
                .buttonStyle(BasicButtonStyleUtil())
            }
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
