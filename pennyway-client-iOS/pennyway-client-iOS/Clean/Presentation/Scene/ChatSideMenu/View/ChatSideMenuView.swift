//
//  ChatSideMenuView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

struct ChatSideMenuView: View {
    @Binding var isPresented: Bool

    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 0) {
                Spacer()

                SideMenuContent
                    .padding(.leading, 106 * DynamicSizeFactor.factor())
                    .transition(.move(edge: .trailing))
            }
            .edgesIgnoringSafeArea(.vertical)
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

    private var SideMenuContent: some View {
        VStack(spacing: 9 * DynamicSizeFactor.factor()) {
            SideMenuCell(title: "채팅방 설정", imageName: "icon_checkwithsomeone")
            SideMenuCell(title: "알람 설정", imageName: "icon_notificationsetting")
            ChatUserCell(name: "직장인은 바다여왕", status: "내")
            ChatUserCell(name: "볼링하는 바니걸", status: "참여")
        }
        .padding(.horizontal, 25)
        .frame(maxHeight: .infinity)
        .background(
            RoundedCornerUtil(radius: 8, corners: [.topLeft, .bottomLeft])
                .fill(Color("White01"))
        )
    }
}
