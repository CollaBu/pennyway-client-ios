//
//  ChatRoomSettingView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import SwiftUI

struct ChatRoomSettingView: View {
    @StateObject private var keyboardHandler = KeyboardManager()
    @State private var isPublic: Bool = false // 토글 상태를 관리하는 변수
    @State private var chatRoomName: String = ""
    @State private var password: String = ""
    @State private var showCompleteToastPopup: Bool = false
    @State private var showImagePopUp: Bool = false
    @State private var selectedUIImage: UIImage? // 이미지에서 선택된 이미지의 상태를 관리하는 변수
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @EnvironmentObject var viewModelWrapper: ChatRoomViewModelWrapper

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

                        // 공개 범위 설정
                        PublicScopeSection

                        Spacer()
                    }
                    .padding(.bottom, keyboardHandler.keyboardHeight > 0 ? 20 : nil)
                }
                .padding(.bottom, keyboardHandler.keyboardHeight)
                .animation(keyboardHandler.keyboardHeight > 0 ? .easeOut(duration: 0.3) : nil)
            }
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
                            showCompleteToastPopup = true
                        }, label: {
                            Text("완료")
                                .font(.H4MediumFont())
                                .platformTextColor(color: .mint03)
                                .padding(.trailing, 10)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
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
        .sheet(isPresented: $showImagePicker, onDismiss: {
            // 사진 클릭한 경우
            showImagePopUp = false

            if let selectedUIImage {
                self.selectedUIImage = selectedUIImage
//                chatViewModelWrapper.makeChatViewModel.uploadImage(image: selectedUIImage)
            }

        }) {
            ImagePicker(image: $selectedUIImage, isActive: $showImagePicker, sourceType: sourceType)
                .edgesIgnoringSafeArea(.bottom)
        }
    }

    /// 채팅방 이름 입력 섹션
    private var ChatRoomNameSection: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("채팅방 이름")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("Gray01"))
                    .frame(height: 46 * DynamicSizeFactor.factor())

                if chatRoomName.isEmpty {
                    Text(viewModelWrapper.chatRoomViewModel.roomData.value?.title ?? "")
                        .font(.H4MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.leading, 13 * DynamicSizeFactor.factor())
                }

                TextField("", text: $chatRoomName)
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.horizontal, 13 * DynamicSizeFactor.factor())
            }
        }
        .padding(.horizontal, 20)
    }

    /// 공개 범위 설정 섹션
    private var PublicScopeSection: some View {
        VStack(alignment: .leading) {
            Text("공개 범위")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))

            Spacer().frame(height: 8 * DynamicSizeFactor.factor())

            HStack {
                Text("채팅방 비밀번호 설정")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer()

                Toggle(isOn: $isPublic) {}
                    .toggleStyle(CustomToggleStyle(hasAppeared: .constant(true)))
            }

            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            if !isPublic {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    TextField("", text: $password)
                        .font(.H4MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                        .keyboardType(.numberPad)
                        .onChange(of: password) { pw in
                            if pw.count > 6 {
                                password = String(pw.prefix(6))
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ChatRoomSettingView()
}
