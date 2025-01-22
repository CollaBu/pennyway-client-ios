//
//  ChatRoomSettingView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import SwiftUI

struct ChatRoomSettingView: View {
    @EnvironmentObject var viewModelWrapper: ChatRoomViewModelWrapper
    @StateObject private var keyboardHandler = KeyboardManager()
    @State private var isSecret: Bool = false // 채팅방 공개 상태를 관리하는 변수
    @State private var isPasswordValid: Bool = true // 비밀번호 유효성 판단하는 변수
    @State private var isFormValid: Bool = true // 채팅방 수정 폼 유효성 판단하는 변수
    @State private var description: String = ""
    @State private var chatRoomName: String = ""
    @State private var password: String = ""
    @State private var showCompleteToastPopup: Bool = false

    // title ui 관련
    private var chatRoomTitle = "채팅방 이름*"
    let baseAttribute: BaseAttribute = .init(font: .B1MediumFont(), color: Color(.gray04))
    let stringAttribute: StringAttribute = .init(text: "*", font: .B1MediumFont(), color: Color(.mint03))

    // 이미지 관련
    @State private var showImagePopUp: Bool = false
    @State private var selectedUIImage: UIImage? // 이미지에서 선택된 이미지의 상태를 관리하는 변수
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        // 상단 여백 및 아이콘 이미지
                        Spacer().frame(height: 20 * DynamicSizeFactor.factor())

                        if let image = selectedUIImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 88 * DynamicSizeFactor.factor(), height: 88 * DynamicSizeFactor.factor())
                                .cornerRadius(12 * DynamicSizeFactor.factor())
                        } else {
                            Image("icon_illust_maintain_goal")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 88 * DynamicSizeFactor.factor(), height: 88 * DynamicSizeFactor.factor())
                                .cornerRadius(12 * DynamicSizeFactor.factor())
                        }

                        Spacer().frame(height: 16 * DynamicSizeFactor.factor())

                        // 채팅방 커버 수정 버튼
                        CustomRoundedBtn(title: "채팅방 커버 변경", fontColor: Color("Mint03"), backgroundColor: Color("Mint01"), style: .large) {
                            showImagePopUp = true
                        }

                        Spacer().frame(height: 25 * DynamicSizeFactor.factor())

                        // 채팅방 이름 입력
                        ChatRoomNameSection

                        Spacer().frame(height: 32 * DynamicSizeFactor.factor())

                        // 설명 입력
                        RoomDescriptionSection

                        Spacer().frame(height: 32 * DynamicSizeFactor.factor())

                        // 공개 범위 설정
                        PublicScopeSection
                    }
                    .padding(.bottom, keyboardHandler.keyboardHeight > 0 ? 20 : nil)
                }
                .padding(.bottom, keyboardHandler.keyboardHeight)
                .animation(keyboardHandler.keyboardHeight > 0 ? .easeOut(duration: 0.3) : nil)
            }
            .overlay(
                Group {
                    if showCompleteToastPopup {
                        CustomToastView(message: "변경 사항이 저장되었어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 34 * DynamicSizeFactor.factor())
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    if showCompleteToastPopup {
                                        showCompleteToastPopup = false
                                    }
                                }
                            }
                    }
                }, alignment: .bottom
            )
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarColor(UIColor(named: "White01"), title: "채팅방 설정")
            .background(Color("White01"))
            .setTabBarVisibility(isHidden: true)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationBackButton()
                        .padding(.trailing, 10)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            validateForm()

                            if isFormValid {
                                viewModelWrapper.editChatRoomViewModel.updateEditRoomData(title: chatRoomName, password: password)
                                viewModelWrapper.editChatRoomViewModel.editChatRoom { success in
                                    if success {
                                        showCompleteToastPopup = true
                                    }
                                }
                            }
                        }, label: {
                            Text("완료")
                                .font(.H4MediumFont())
                                .platformTextColor(color: isFormValid ? .mint03 : .gray04)
                                .padding(.trailing, 10)
                                .disabled(isFormValid)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .onAppear {
                chatRoomName = viewModelWrapper.editRoomData?.title ?? ""
                description = viewModelWrapper.editRoomData?.description ?? ""
                password = viewModelWrapper.editRoomData?.password ?? ""
                isSecret = !password.isEmpty
            }

            if showImagePopUp {
                Color(.black01).edgesIgnoringSafeArea(.all)

                ChatPhotoActionsPopUp(isPresented: $showImagePopUp,
                                      showPopUpView: $showImagePopUp,
                                      isHiddenTabBar: .constant(true),
                                      showImagePicker: $showImagePicker,
                                      selectedUIImage: $selectedUIImage,
                                      sourceType: $sourceType)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            // 사진 클릭한 경우
            showImagePopUp = false

            if let selectedUIImage {
                self.selectedUIImage = selectedUIImage
                viewModelWrapper.editChatRoomViewModel.uploadImage(image: selectedUIImage)
            }

        }) {
            ImagePicker(image: $selectedUIImage, isActive: $showImagePicker, sourceType: sourceType)
                .edgesIgnoringSafeArea(.bottom)
        }
    }

    /// 채팅방 이름 입력 섹션
    private var ChatRoomNameSection: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            chatRoomTitle.toAttributesText(base: baseAttribute, stringAttribute)
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))
                .padding(.horizontal, 20)

            CustomInputView(inputText: $chatRoomName, isSecureText: false, placeholderColor: .gray07)
                .onChange(of: chatRoomName) { _ in
                    if chatRoomName.count > 30 {
                        chatRoomName = String(chatRoomName.prefix(30))
                    }
                    if chatRoomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isFormValid = false
                    } else {
                        isFormValid = true
                    }
                }
        }
    }

    /// 설명 입력 섹션
    private var RoomDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("설명")
                .font(.B1MediumFont())
                .platformTextColor(color: Color(.gray04))
                .padding(.horizontal, 20)

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 106 * DynamicSizeFactor.factor())

                    TextEditor(text: $description)
                        .font(.H4MediumFont())
                        .padding(.horizontal, 10)
                        .padding(.top, 8)
                        .zIndex(0)
                        .colorMultiply(Color("Gray01"))
                        .cornerRadius(6)
                        .TextAutocapitalization()
                        .AutoCorrectionExtensions()
                        .onChange(of: description) { _ in
                            if description.count > 100 {
                                description = String(description.prefix(100))
                            }
                        }
                        .frame(height: 106 * DynamicSizeFactor.factor())
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.horizontal, 20)
        }
    }

    /// 공개 범위 설정 섹션
    private var PublicScopeSection: some View {
        VStack(alignment: .leading) {
            Group {
                Text("공개 범위")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray04"))

                Spacer().frame(height: 8 * DynamicSizeFactor.factor())

                HStack {
                    Text("채팅방 비밀번호 설정")
                        .font(.ButtonH4SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer()

                    Toggle(isOn: $isSecret) {}
                        .toggleStyle(CustomToggleStyle(hasAppeared: .constant(true)))
                }
            }.padding(.horizontal, 20)

            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            if isSecret {
                CustomInputView(inputText: $password, onCommit: {
                    validatePassword()
                    validateForm()
                }, isSecureText: false, keyboardType: .numberPad)
                    .onChange(of: password) { pw in
                        // 숫자만 필터링
                        let filtered = pw.filter { $0.isNumber }
                        if filtered != pw {
                            password = filtered
                        }
                        // 최대 6자리까지만 허용
                        if password.count >= 6 {
                            password = String(password.prefix(6))
                        }
                    }
            }

            if isSecret, !isPasswordValid, !password.isEmpty {
                Text("6자리의 숫자 비밀번호가 필요해요")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color(.red03))
                    .padding(.horizontal, 20)
            }
        }
    }

    private func validateForm() {
        if chatRoomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isFormValid = false
        } else {
            if isSecret {
                isFormValid = isPasswordValid
            } else {
                isFormValid = true
                password = ""
            }
        }
    }

    private func validatePassword() {
        if password.count >= 6 {
            isPasswordValid = true
        } else {
            isPasswordValid = false
        }
    }
}

#Preview {
    ChatRoomSettingView()
}
