//
//  ChatSideMenuView.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 아우신얀 on 10/10/24.
//

import SwiftUI

// MARK: - ChatSideMenuView

struct ChatSideMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModelWrapper: ChatRoomViewModelWrapper
    @State private var isAlarmOn: Bool = false
    @State private var showExitPopUp: Bool = false
    @State private var showDeletePopUp: Bool = false
    @State private var showChatUserView: Bool = false
    @State private var selectedUser: ChatMemberItemModel? = nil
    @State private var isInitialLoad: Bool = true // 초기 로드 여부
    @Binding var isSideMenuPresented: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer()
                
                SideMenuContent(isAlarmOn: $isAlarmOn, showExitPopUp: $showExitPopUp, showDeletePopUp: $showDeletePopUp, members: viewModelWrapper.chatUserData, onUserSelect: { user in
                    selectedUser = user
                })
                .padding(.leading, 105 * DynamicSizeFactor.factor())
                .transition(.move(edge: .trailing))
            }
            
            if viewModelWrapper.showErrorPopUp {
                ZStack {
                    InfoPopUpView(showingPopUp: $viewModelWrapper.showErrorPopUp, titleLabel: "채팅방을 나갈 수 없어요", subLabel: "방장 권한을 넘긴 후 다시 시도해주세요", iconType: .error)
                        .edgesIgnoringSafeArea(.vertical)
                }
                .edgesIgnoringSafeArea(.vertical)
            }
            
            if showExitPopUp {
                CustomPopUpView(showingPopUp: $showExitPopUp,
                                titleLabel: "\(viewModelWrapper.roomData?.title ?? "")",
                                subTitleLabel: "채팅방을 나가시겠어요?",
                                firstBtnAction: { self.showExitPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showExitPopUp = false
                                    if let chatRoomId = viewModelWrapper.roomData?.id {
                                        viewModelWrapper.chatRoomViewModel.deleteChatRoom(chatRoomId: chatRoomId) { success in
                                            
                                            if success {
                                                Log.debug("[ChatSideMenuView]: 채팅방 나가기 성공")
                                            } else {
                                                Log.debug("[ChatSideMenuView]: 채팅방 나가기 실패")
                                            }
                                        }
                                    }
                                },
                                secondBtnLabel: "나가기",
                                secondBtnColor: Color("Red03")
                )
                .edgesIgnoringSafeArea(.vertical)
            }
            
            if showDeletePopUp {
                CustomPopUpView(showingPopUp: $showExitPopUp,
                                titleLabel: "채팅방 삭제",
                                subTitleLabel: "    채팅방을 삭제하시겠어요?\n삭제된 내용은 복구할 수 없어요",
                                firstBtnAction: { self.showDeletePopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showDeletePopUp = false

                                    if let chatRoomId = viewModelWrapper.roomData?.id {
                                        viewModelWrapper.chatRoomViewModel.deleteChatRoomByAdmin(chatRoomId: chatRoomId) { success in
                                            
                                            if success {
                                                Log.debug("[ChatSideMenuView]: 채팅방장이 채팅방 삭제 성공")
                                            } else {
                                                Log.debug("[ChatSideMenuView]: 채팅방장이 채팅방 삭제 실패")
                                            }
                                        }
                                    }
                                },
                                secondBtnLabel: "삭제하기",
                                secondBtnColor: Color("Red03")
                )
                .edgesIgnoringSafeArea(.vertical)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: viewModelWrapper.isDeleteSuccess) { success in
            if success {
                self.presentationMode.wrappedValue.dismiss()
                isSideMenuPresented = false
            }
        }
        .onChange(of: selectedUser) { newValue in
            showChatUserView = newValue != nil
        }
        .onAppear {
            isAlarmOn = viewModelWrapper.roomDetailData?.myInfo.notifyEnabled ?? false
            isInitialLoad = false // 초기 로드 이후 false로 변경
        }
        .onChange(of: isAlarmOn) { newValue in
            guard !isInitialLoad else {
                return
            } // 초기 로드 시 무시

            let alarmType = newValue ? ChatRoomAlarmType.on : ChatRoomAlarmType.off

            viewModelWrapper.editChatRoomViewModel.handleChatRoomAlarm(chatRoomId: viewModelWrapper.roomData?.id ?? 0, chatRoomAlarm: alarmType) { success in
                if success {
                    Log.debug("[ChatSideMenuView]: 채팅방 알람 설정 - \(alarmType) 성공")
                    viewModelWrapper.chatRoomViewModel.updateAlarmSetting(setting: isAlarmOn)
                } else {
                    Log.debug("[ChatSideMenuView]: 채팅방 알람 설정 - \(alarmType) 실패")
                }
            }
        }
        .fullScreenCover(isPresented: $showChatUserView) {
            if let user = selectedUser {
                ChatUserInfoView(isSideMenuPresented: $isSideMenuPresented, viewModelWrapper: viewModelWrapper, user: user, myInfo: viewModelWrapper.roomDetailData?.myInfo, chatRoom: viewModelWrapper.roomData) // 선택된 사용자 정보를 전달
                    .ignoresSafeArea()
                    .onDisappear {
                        selectedUser = nil // 뷰가 닫힐 때 선택된 사용자 초기화
                    }
            }
        }
    }
}

// MARK: - SideMenuContent

private struct SideMenuContent: View {
    @Binding var isAlarmOn: Bool
    @Binding var showExitPopUp: Bool
    @Binding var showDeletePopUp: Bool
    let members: [ChatMemberItemModel]
    let onUserSelect: (ChatMemberItemModel) -> Void
    
    private let currentUserId = getUserData()?.id ?? 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 29 * DynamicSizeFactor.factor())
            
            Text("방 정보")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))
            
            Spacer().frame(height: 17 * DynamicSizeFactor.factor())
            
            SideMenuCells
            
            CellDivider
            
            ChatUserCells
            
            Spacer()
            
            HStack {
                ExitButton

                Spacer()
                
                // 방장에게만 보이도록 표시
                if !members.isEmpty {
                    if members[0].role.rawValue == Role.admin.rawValue {
                        DeleteButton
                    }
                }
            }
            
            Spacer().frame(height: 31 * DynamicSizeFactor.factor())
        }
        .padding(.horizontal, 25 * DynamicSizeFactor.factor())
        .frame(maxHeight: .infinity)
        .background(
            RoundedCornerUtil(radius: 8, corners: [.topLeft, .bottomLeft])
                .fill(Color("White01"))
        )
    }
    
    private var SideMenuCells: some View {
        VStack {
            if !members.isEmpty {
                if members[0].role.rawValue == Role.admin.rawValue { // 첫번째 사용자(나)가 방장인지 확인 후 ui
                    NavigationLink(destination: ChatRoomSettingView()) {
                        SideMenuCell(title: "채팅방 설정", imageName: "icon_checkwithsomeone_no_padding", isAlarmCell: false, isAlarmOn: .constant(false))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            SideMenuCell(title: "알람 설정", imageName: "icon_notificationsetting_no_padding", isAlarmCell: true, isAlarmOn: $isAlarmOn)
        }
    }
    
    private var CellDivider: some View {
        VStack {
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            
            Divider()
                .overlay(Color("Gray02"))
                .frame(height: 0.33 * DynamicSizeFactor.factor())
                .padding(.horizontal, 25 * DynamicSizeFactor.factor())
            
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        }
    }

    private var ChatUserCells: some View {
        ForEach(members) { user in
            Button(action: {
                onUserSelect(user)
            }) {
                ChatUserCell(member: user, currentUserId: currentUserId)
            }
        }
    }

    private var ExitButton: some View {
        Button(action: {
            showExitPopUp = true
        }, label: {
            Image("icon_chat_close")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
        })
    }
    
    private var DeleteButton: some View {
        Button(action: {
            showDeletePopUp = true
        }, label: {
            Image("icon_imagedelete")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
        })
    }
}
