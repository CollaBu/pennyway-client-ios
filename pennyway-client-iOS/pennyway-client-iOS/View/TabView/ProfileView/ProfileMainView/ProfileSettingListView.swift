import os.log
import SwiftUI

// MARK: - ProfileSettingListView

struct ProfileSettingListView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State private var showingPopUp = false

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 32 * DynamicSizeFactor.factor())

                LazyVStack(spacing: 0) {
                    SectionView(showingPopUp: $showingPopUp, title: "내 정보", itemsWithIcons: [("내 정보 수정", "icon_modifyingprofile"), ("내가 쓴 글", "icon_list"), ("스크랩", "icon_modifyingprofile"), ("비밀번호 변경", "icon_modifyingprofile")])
                    SectionView(showingPopUp: $showingPopUp, title: "앱 설정", itemsWithIcons: [("알림 설정", "icon_notificationsetting")])
                    SectionView(showingPopUp: $showingPopUp, title: "이용안내", itemsWithIcons: [("문의하기", "icon_checkwithsomeone")])
                    SectionView(showingPopUp: $showingPopUp, title: "기타", itemsWithIcons: [("로그아웃", "icon_logout"), ("회원탈퇴", "icon_cancelmembership")])
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("White01"))

            if showingPopUp {
                Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
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
                    appViewModel.logout()
                    showingPopUp = false
                } else {
                    os_log("fail logout", log: .default, type: .debug)
                }
            }
        }
    }
}

// MARK: - SectionView

struct SectionView: View {
    @Binding var showingPopUp: Bool

    let title: String
    let itemsWithIcons: [(String, String)]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.B2SemiboldFont())
                .platformTextColor(color: Color("Gray04"))
                .background(Color(UIColor.systemBackground))

            Spacer().frame(height: 14 * DynamicSizeFactor.factor())

            ForEach(itemsWithIcons, id: \.0) { item, icon in
                Button(action: {
                    if item == "로그아웃" {
                        showingPopUp = true
                    }
                }, label: {
                    HStack {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22 * DynamicSizeFactor.factor(), height: 22 * DynamicSizeFactor.factor(), alignment: .leading)

                        Text(item)
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.vertical, 7)
                    }
                })
            }
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 21)
    }
}
