//
//  ChatSideMenuView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

// MARK: - ChatSideMenuView

struct ChatSideMenuView: View {
    @State private var isAlarmOn: Bool = false
    @State private var showExitPopUp: Bool = false
    @State private var showChatUserView: Bool = false
    @State private var selectedUser: ChatMemberItemModel? = nil
    @EnvironmentObject var viewModelWrapper: ChatRoomViewModelWrapper
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer()
                
                SideMenuContent(isAlarmOn: $isAlarmOn, showExitPopUp: $showExitPopUp, members: viewModelWrapper.chatUserData, onUserSelect: { user in
                    selectedUser = user
                })
                .padding(.leading, 105 * DynamicSizeFactor.factor())
                .transition(.move(edge: .trailing))
            }
            
            if showExitPopUp {
                CustomPopUpView(showingPopUp: $showExitPopUp,
                                titleLabel: "\(viewModelWrapper.roomData?.title ?? "")",
                                subTitleLabel: "채팅방을 나가시겠어요?",
                                firstBtnAction: { self.showExitPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showExitPopUp = false
                                },
                                secondBtnLabel: "나가기",
                                secondBtnColor: Color("Red03")
                )
                .edgesIgnoringSafeArea(.vertical)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: selectedUser) { newValue in
            showChatUserView = newValue != nil
        }
        .fullScreenCover(isPresented: $showChatUserView) {
            if let user = selectedUser {
                ChatUserInfoView(viewModelWrapper: viewModelWrapper, user: user, myInfo: viewModelWrapper.roomDetailData?.myInfo, chatRoom: viewModelWrapper.roomData!) // 선택된 사용자 정보를 전달
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
    let members: [ChatMemberItemModel]
    let onUserSelect: (ChatMemberItemModel) -> Void
    
    private let currentUserId = getUserData()!.id
    
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
            
            ExitButton
            
            Spacer().frame(height: 31 * DynamicSizeFactor.factor())
        }
        .padding(.horizontal, 25)
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
}
