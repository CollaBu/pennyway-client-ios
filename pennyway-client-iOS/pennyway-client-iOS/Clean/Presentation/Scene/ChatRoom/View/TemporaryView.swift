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
    var body: some View {
        NavigationAvailable {
            VStack {
                Button(action: {
                    navigate = true
                }, label: {
                    Text("버튼")
                })

                NavigationLink(destination: ChatView(), isActive: $navigate) {}
                    .hidden()
            }
        }
    }
}
