//
//  TemporaryView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - TemporaryView

struct TemporaryView: View {
    @State private var showChatUserInfo = false
    @State private var isNavigate = false

    var body: some View {
        NavigationAvailable {
            Button(action: {
                showChatUserInfo = true
            }, label: {
                Text("Button")
            })

            Button(action: {
                isNavigate = true
            }, label: {
                Text("Btn")
            })
            .setTabBarVisibility(isHidden: false)
            NavigationLink(destination: ChatView(), isActive: $isNavigate) {}

                .fullScreenCover(isPresented: $showChatUserInfo) {
                    ChatUserInfoView()
                        .ignoresSafeArea()
                }
        }
    }
}
