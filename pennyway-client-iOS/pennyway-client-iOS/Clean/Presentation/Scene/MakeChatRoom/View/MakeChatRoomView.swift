
import SwiftUI

struct MakeChatRoomView: View {
    @State var roomTitle = "" // 채팅방 제목을 관리하는 함수
    @State var content = "" // 채팅방 설명을 관리하는 변수
    @State private var isPublic: Bool = false // 토글 상태를 관리하는 변수
    @State var password = "" // 비밀번호 입력을 관리하는 변수

    let titleCustomTextList: [String] = ["제목*"]
    let baseAttribute: BaseAttribute = .init(font: .B1MediumFont(), color: Color("Gray04"))
    let stringAttribute: StringAttribute = .init(text: "*", font: .B1MediumFont(), color: Color("Mint03"))

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 27 * DynamicSizeFactor.factor())

                    RoomTitleInput(roomTitle: $roomTitle, title: titleCustomTextList[0], placeholder: "소비 금액을 작성해 주세요", baseAttribute: baseAttribute, stringAttribute: stringAttribute)

                    Spacer().frame(height: 23 * DynamicSizeFactor.factor())

                    RoomDescriptionInput

                    Spacer().frame(height: 23 * DynamicSizeFactor.factor())

                    privacySetting

                    Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                    settingChatRoomImage

                    Spacer()
                }
                .frame(maxHeight: .infinity)

                Spacer()
            }
            CustomBottomButton(action: {}, label: "채팅방 생성", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "White01"), title: "채팅방 만들기")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White01"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }

    private var RoomDescriptionInput: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("설명")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))
                .padding(.horizontal, 20)

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 106 * DynamicSizeFactor.factor())

                    TextEditor(text: $content)
                        .font(.B1MediumFont())
                        .padding(.horizontal, 10)
                        .padding(.top, 8)
                        .zIndex(0)
                        .colorMultiply(Color("Gray01"))
                        .cornerRadius(6)
                        .TextAutocapitalization()
                        .AutoCorrectionExtensions()
                        .onChange(of: content) { _ in
                            if content.count > 500 {
                                content = String(content.prefix(500))
                            }
                        }
                        .frame(height: 123)

                    if content.isEmpty {
                        Text("채팅방 소개를 해주세요")
                            .font(.H4MediumFont())
                            .padding(.leading, 14)
                            .padding(.top, 16)
                            .platformTextColor(color: Color("Gray03"))
                            .cornerRadius(6)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.horizontal, 20)
        }
    }

    private var privacySetting: some View {
        VStack(alignment: .leading, spacing: 7 * DynamicSizeFactor.factor()) {
            Text("공개 범위")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))
                .padding(.horizontal, 20)

            HStack {
                Text("채팅방 비밀번호 설정")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("Gray06"))

                Spacer()

                Toggle(isOn: $isPublic) {}
                    .toggleStyle(CustomToggleStyle(hasAppeared: $isPublic))
            }
            .padding(.horizontal, 20)

            if isPublic {
                Spacer().frame(height: 1)

                CustomInputView(inputText: $password, placeholder: "6자리의 숫자 비밀번호가 필요해요", isSecureText: false)
            }
        }
    }

    private var settingChatRoomImage: some View {
        VStack(alignment: .leading) {
            Text("채팅방 사진")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))

            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            Button(action: {}, label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(6)
                        .frame(width: 57 * DynamicSizeFactor.factor(), height: 57 * DynamicSizeFactor.factor())
                        .platformTextColor(color: Color("Gray02"))

                    Image("icon_navigation_add")
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                }
            })
            .buttonStyle(PlainButtonStyle())

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MakeChatRoomView()
}
