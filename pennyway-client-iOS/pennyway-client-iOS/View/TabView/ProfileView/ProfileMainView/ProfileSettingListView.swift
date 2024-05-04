import SwiftUI

// MARK: - ProfileSettingListView

struct ProfileSettingListView: View {
<<<<<<< HEAD
    @State private var showingPopUp = false // 모든 섹션에서 공유할 상태
=======
    @State private var showingPopUp = true

    var body: some View {
        VStack {
            Spacer().frame(height: 32 * DynamicSizeFactor.factor())
>>>>>>> 03145876f4ccb015d996ed411e2806bc1d6c9c1b

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
                CustomPopUpView(showingPopUp: $showingPopUp, titleLabel: "로그아웃", subTitleLabel: "로그아웃하시겠어요?", firstBtnLabel: "취소", secondBtnLabel: "로그아웃", firstBtnColor: Color("Gray02"), secondBtnColor: Color("Red02"), firstBtnTextColor: Color("Gray04"), secondBtnTextColor: Color("White01"))
            }
        }
    }
}

// MARK: - SectionView

struct SectionView: View {
<<<<<<< HEAD
    @Binding var showingPopUp: Bool // 상위 뷰에서 받는 바인딩 상태
=======
    @State private var showingPopUp = true
>>>>>>> 03145876f4ccb015d996ed411e2806bc1d6c9c1b
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
<<<<<<< HEAD
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

=======
                if item == "로그아웃" {
                    Button(action: {
//                        LogoutPopUpView(showingPopUp: $showingPopUp, titleLabel: "로그아웃", subTitleLabel: "로그아웃하시겠어요?", firstBtnLabel: "취소", secondBtnLabel: "로그아웃")
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
                } else {
                    HStack {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22 * DynamicSizeFactor.factor(), height: 22 * DynamicSizeFactor.factor(), alignment: .leading)

>>>>>>> 03145876f4ccb015d996ed411e2806bc1d6c9c1b
                        Text(item)
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.vertical, 7)
                    }
<<<<<<< HEAD
                })
=======
                }
>>>>>>> 03145876f4ccb015d996ed411e2806bc1d6c9c1b
            }
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 21)
    }
}
