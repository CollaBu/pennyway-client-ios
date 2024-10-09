//
//  ChatSideMenuView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

struct ChatSideMenuView: View {
    @Binding var isPresented: Bool
    @State private var isAlarmOn: Bool = false
    @State private var showSideMenuContent: Bool = false

    var body: some View {
        HStack(spacing: 0) {
            Spacer()

            SideMenuContent
                .padding(.leading, 105 * DynamicSizeFactor.factor())
                .transition(.move(edge: .trailing)) // Apply the transition here
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
        .onAppear {
            // Delay showing the content to apply the transition after the appearance of ChatSideMenuView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    showSideMenuContent = true
                }
            }
        }
    }

    private var SideMenuContent: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 29 * DynamicSizeFactor.factor())

            Text("방 정보")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))

            Spacer().frame(height: 17 * DynamicSizeFactor.factor())

            if showSideMenuContent {
                SideMenuCell(title: "채팅방 설정", imageName: "icon_checkwithsomeone", isAlarmCell: false, isAlarmOn: .constant(false))
                SideMenuCell(title: "알람 설정", imageName: "icon_notificationsetting", isAlarmCell: true, isAlarmOn: $isAlarmOn)

                Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                Divider()
                    .overlay(Color("Gray02"))
                    .frame(height: 0.33)
                    .padding(.horizontal, 25 * DynamicSizeFactor.factor())

                Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                ForEach(mockMembers) { user in
                    ChatUserCell(member: user, currentUserId: 102)
                }
            }

            Spacer()

            Button(action: {}, label: {
                Image("icon_chat_close")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
            })

            Spacer().frame(height: 31 * DynamicSizeFactor.factor())
        }
        .padding(.horizontal, 25 * DynamicSizeFactor.factor())
        .frame(maxHeight: .infinity)
        .background(
            RoundedCornerUtil(radius: 8, corners: [.topLeft, .bottomLeft])
                .fill(Color("White01"))
        )
    }
}
