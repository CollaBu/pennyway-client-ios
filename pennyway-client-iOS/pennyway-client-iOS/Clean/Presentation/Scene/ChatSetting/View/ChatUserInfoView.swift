//
//  ChatUserInfoView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/11/24.
//

import SwiftUI

// MARK: - ChatUserInfoView

struct ChatUserInfoView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                VStack(spacing: 14 * DynamicSizeFactor.factor()) {
                    Image("icon_illust_maintain_goal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("격정하는 바다오리")
                        .font(.headline)
                }
                .offset(y: -50)
                .frame(height: 200)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "person.fill")
                            Text("방장 넘기기")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                            Text("내보내기")
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                    }
                }
            }
            .frame(height: 173 * DynamicSizeFactor.factor())
            .frame(maxWidth: .infinity)
            .padding(.bottom, 35 * DynamicSizeFactor.factor())
            .background(Color(.white01))
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
//            Image("image_chat_background")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .border(Color.black)
            Color.red.opacity(0.1)
        )
    }
}

#Preview {
    ChatUserInfoView()
}
