//
//  ChatSideMenuView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

// MARK: - ChatSideMenuView

struct ChatSideMenuView: View {
    @Binding var isPresented: Bool
    @State private var isAlarmOn: Bool = false
    @State private var showExitPopUp: Bool = false

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer()
                
                SideMenuContent(isAlarmOn: $isAlarmOn, showExitPopUp: $showExitPopUp)
                    .padding(.leading, 105 * DynamicSizeFactor.factor())
                    .transition(.move(edge: .trailing))
            }
            
            if showExitPopUp {
                CustomPopUpView(showingPopUp: $showExitPopUp,
                                titleLabel: "\(mockChatRoom.title)",
                                subTitleLabel: "채팅방을 나가시겠어요?",
                                firstBtnAction: { self.showExitPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showExitPopUp = false
                                },
                                secondBtnLabel: "나가기",
                                secondBtnColor: Color("Red03")
                )
                .analyzeEvent(ProfileEvents.oauthUnlinkPopUp)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
        )
    }
}

// MARK: - SideMenuContent

private struct SideMenuContent: View {
    @Binding var isAlarmOn: Bool
    @Binding var showExitPopUp: Bool
    
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
        .padding(.horizontal, 25 * DynamicSizeFactor.factor())
        .frame(maxHeight: .infinity)
        .background(
            RoundedCornerUtil(radius: 8, corners: [.topLeft, .bottomLeft])
                .fill(Color("White01"))
        )
    }
    
    private var SideMenuCells: some View {
        VStack {
            if mockMembers[1].role == "Admin" {
                SideMenuCell(title: "채팅방 설정", imageName: "icon_checkwithsomeone", isAlarmCell: false, isAlarmOn: .constant(false))
            }
            
            SideMenuCell(title: "알람 설정", imageName: "icon_notificationsetting", isAlarmCell: true, isAlarmOn: $isAlarmOn)
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
        ForEach(mockMembers) { user in
            ChatUserCell(member: user, currentUserId: 102)
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
