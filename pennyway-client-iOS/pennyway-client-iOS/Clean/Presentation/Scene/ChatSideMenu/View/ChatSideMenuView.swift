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

    var body: some View {
        HStack(spacing: 0) {
            Spacer()

            SideMenuContent
                .padding(.leading, 105 * DynamicSizeFactor.factor())
                .transition(.move(edge: .trailing))
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

    private var SideMenuContent: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 29 * DynamicSizeFactor.factor())

            Text("방 정보")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))

            Spacer().frame(height: 17 * DynamicSizeFactor.factor())

            SideMenuCell(title: "채팅방 설정", imageName: "icon_checkwithsomeone", isAlarmCell: false, isAlarmOn: .constant(false))
            SideMenuCell(title: "알람 설정", imageName: "icon_notificationsetting", isAlarmCell: true, isAlarmOn: $isAlarmOn)

            Divider()
                .overlay(Color("Gray02"))
                .frame(height: 0.33)
                .padding(.horizontal, 25 * DynamicSizeFactor.factor())

            ChatUserCell(name: "직장인은 바다여왕", status: "내")
            ChatUserCell(name: "볼링하는 바니걸", status: "참여")

            Spacer()
        }
        .padding(.horizontal, 25 * DynamicSizeFactor.factor())
        .frame(maxHeight: .infinity)
        .background(
            RoundedCornerUtil(radius: 8, corners: [.topLeft, .bottomLeft])
                .fill(Color("White01"))
        )
    }
}
