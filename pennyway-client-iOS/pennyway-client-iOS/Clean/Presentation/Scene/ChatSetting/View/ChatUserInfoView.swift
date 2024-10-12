//
//  ChatUserInfoView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/11/24.
//

import SwiftUI

// MARK: - ChatUserInfoView

struct ChatUserInfoView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()

            VStack{
                VStack(spacing: 14 * DynamicSizeFactor.factor()) {
                    Rectangle()
                        .platformTextColor(color: .clear)
                        .frame(width: 90 * DynamicSizeFactor.factor(), height: 90 * DynamicSizeFactor.factor())
                        .background(
                            Image("icon_illust_maintain_goal")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90 * DynamicSizeFactor.factor(), height: 90 * DynamicSizeFactor.factor())
                                .clipped()
                        )
                        .cornerRadius(17)
                        .overlay(
                            RoundedRectangle(cornerRadius: 17)
                                .inset(by: -1.5 * DynamicSizeFactor.factor())
                                .stroke(.white, lineWidth: 3)
                        )

                    Text("격정하는 바다오리")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: .gray07)
                }
                .offset(y: -40 * DynamicSizeFactor.factor())

                HStack(spacing: 14 * DynamicSizeFactor.factor()) {
                    ActionButton(title: "방장 넘기기", icon: "person.fill", textColor: .mint03, backgroundColor: .mint01, action: {})
                    ActionButton(title: "내보내기", icon: "hand.raised.fill", textColor: .red03, backgroundColor: .red01, action: {})
                }
                
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())
            }
            .frame(height: 173 * DynamicSizeFactor.factor())
            .frame(maxWidth: .infinity)
            .background(Color(.white01))
        }
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
//            Image("image_chat_background")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .border(Color.black)
            Color.red.opacity(0.1)//변경 필요
        )
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {  
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_close")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(5)
                    })
                    .frame(width: 44, height: 44)
                    .buttonStyle(BasicButtonStyleUtil())
                }
            }
        }
    }
}

// MARK: - ActionButton

struct ActionButton: View {
    let title: String
    let icon: String
    let textColor: Color
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                Image(systemName: icon)
                Text(title)
            }
            .frame(width: 130 * DynamicSizeFactor.factor())
            .padding(.vertical, 14)
            .background(backgroundColor)
            .platformTextColor(color: textColor)
            .cornerRadius(6)
        }
    }
}

#Preview {
    ChatUserInfoView()
}
