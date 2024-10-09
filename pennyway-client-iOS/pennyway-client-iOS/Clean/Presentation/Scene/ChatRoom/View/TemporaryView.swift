//
//  TemporaryView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatView

struct TemporaryView: View {
    @State private var navigate = false
    @State private var isNavigate = false

    var body: some View {
        NavigationAvailable {
            Button(action: {
                navigate = true
            }, label: {
                Text("Button")
            })

            Button(action: {
                isNavigate = true
            }, label: {
                Text("Btn")
            })
            .setTabBarVisibility(isHidden: false)
            NavigationLink(destination: ChatSettingView(), isActive: $navigate) {}
            NavigationLink(destination: ChatRoomDetailView(), isActive: $isNavigate) {}
        }
    }
}
