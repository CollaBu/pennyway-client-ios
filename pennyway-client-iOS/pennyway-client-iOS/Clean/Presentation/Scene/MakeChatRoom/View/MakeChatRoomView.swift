import Combine
import SwiftUI

// MARK: - MakeChatRoomView

struct MakeChatRoomView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var roomTitle = "" // 채팅방 제목을 관리하는 함수
    @State var content = "" // 채팅방 설명을 관리하는 변수
    @State private var isPublic: Bool = false // 토글 상태를 관리하는 변수
    @State var password = "" // 비밀번호 입력을 관리하는 변수
    @State private var showPopUpView = false // 사진 선택 팝업 표시여부를 관리하는 변수
    @State private var selectedUIImage: UIImage? // 이미지에서 선택된 이미지의 상태를 관리하는 변수
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @ObservedObject var chatViewModelWrapper: ChatViewModelWrapper

    let titleCustomTextList: [String] = ["제목*"]
    let baseAttribute: BaseAttribute = .init(font: .B1MediumFont(), color: Color("Gray04"))
    let stringAttribute: StringAttribute = .init(text: "*", font: .B1MediumFont(), color: Color("Mint03"))

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Spacer().frame(height: 27 * DynamicSizeFactor.factor())

                        RoomTitleInput(roomTitle: $roomTitle, title: titleCustomTextList[0], baseAttribute: baseAttribute, stringAttribute: stringAttribute)
                            .onChange(of: roomTitle) { newValue in
                                if roomTitle.count > 30 {
                                    roomTitle = String(roomTitle.prefix(30))
                                }
                                chatViewModelWrapper.makeChatViewModel.roomData.value.title = newValue
                                chatViewModelWrapper.makeChatViewModel.validateForm()
                            }

                        Spacer().frame(height: 23 * DynamicSizeFactor.factor())

                        RoomDescriptionInput

                        Spacer().frame(height: 23 * DynamicSizeFactor.factor())

                        privacySetting

                        Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                        settingChatRoomImage

                        Spacer()
                    }

                    Spacer()
                }
                .navigationBarColor(UIColor(named: "White01"), title: "채팅방 만들기")

                Spacer()

                CustomBottomButton(action: {
                    let chatRoomData = MakeChatRoomItemModel(title: roomTitle, description: content, password: password)

                    if chatViewModelWrapper.makeChatViewModel.isFormValid {
                        chatViewModelWrapper.makeChatViewModel.makeChatRoom()
                    }

                }, label: "채팅방 생성", isFormValid: $chatViewModelWrapper.makeChatViewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }
            .setTabBarVisibility(isHidden: true)
            .navigationBarBackButtonHidden(true)
            .background(Color("White01"))
            .edgesIgnoringSafeArea(.bottom)
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
            .sheet(isPresented: $showImagePicker, onDismiss: {
                // 사진 클릭한 경우
                showPopUpView = false

                if let selectedUIImage {
                    self.selectedUIImage = selectedUIImage
                    chatViewModelWrapper.makeChatViewModel.uploadImage(image: selectedUIImage)
                }

            }) {
                ImagePicker(image: $selectedUIImage, isActive: $showImagePicker, sourceType: sourceType)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .onChange(of: chatViewModelWrapper.makeChatViewModel.isDismissView) { isDismissed in
                Log.debug("onChange실행중")

                if isDismissed {
                    self.presentationMode.wrappedValue.dismiss()
                    Log.debug("isDismissed")
                    isDismissed = false
                }
            }

            if showPopUpView {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)

                ChatPhotoActionsPopUp(isPresented: $showPopUpView,
                                      showPopUpView: $showPopUpView,
                                      isHiddenTabBar: .constant(true),
                                      showImagePicker: $showImagePicker,
                                      selectedUIImage: $selectedUIImage,
                                      sourceType: $sourceType,
                                      viewModelWrapper: chatViewModelWrapper)
                    .edgesIgnoringSafeArea(.bottom)
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
                        .font(.H4MediumFont())
                        .padding(.horizontal, 10)
                        .padding(.top, 8)
                        .zIndex(0)
                        .colorMultiply(Color("Gray01"))
                        .cornerRadius(6)
                        .TextAutocapitalization()
                        .AutoCorrectionExtensions()
                        .onChange(of: content) { _ in
                            if content.count > 100 {
                                content = String(content.prefix(100))
                            }
                        }
                        .onChange(of: content) { newValue in
                            chatViewModelWrapper.makeChatViewModel.roomData.value.description = newValue
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
                    .onChange(of: password) { newValue in
                        // 비밀번호가 6자리인 경우에만 유효하게 처리
                        if newValue.count > 6 {
                            password = String(password.prefix(6))
                        }

                        if password.count == 6 {
                            chatViewModelWrapper.makeChatViewModel.roomData.value.password = password
                        } else {
                            chatViewModelWrapper.makeChatViewModel.roomData.value.password = "" // 유효하지 않은 경우 초기화
                        }
                    }
            }
        }
    }

    private var settingChatRoomImage: some View {
        VStack(alignment: .leading) {
            Text("채팅방 사진")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))

            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            if let image = selectedUIImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .background(Color.black.opacity(0.3))
                    .frame(width: 57 * DynamicSizeFactor.factor(), height: 57 * DynamicSizeFactor.factor())
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        Button(action: {
                            showPopUpView.toggle()
                        }) {
                            Image("icon_picture")
                                .frame(width: 15 * DynamicSizeFactor.factor(), height: 15 * DynamicSizeFactor.factor())

                        },
                        alignment: .center
                    )
            } else {
                Button(action: {
                    showPopUpView.toggle()
                }, label: {
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
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - ChatViewModelWrapper

final class ChatViewModelWrapper: ObservableObject {
    var makeChatViewModel: any MakeChatRoomViewModel

    init(makeChatViewModel: MakeChatRoomViewModel) {
        self.makeChatViewModel = makeChatViewModel
    }
}
