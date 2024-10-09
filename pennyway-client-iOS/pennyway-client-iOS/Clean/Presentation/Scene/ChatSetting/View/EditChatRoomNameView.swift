//
//  EditChatRoomNameView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import SwiftUI

struct EditChatRoomNameView: View {
    @State private var inputRoomName = ""
    private let maxLength = 8 // TODO: 최대 길이 수정 필요

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())

                CustomInputView(inputText: $inputRoomName, isSecureText: false, isCustom: false)
                    .onChange(of: inputRoomName) { newValue in
                        if newValue.count > maxLength {
                            inputRoomName = String(newValue.prefix(maxLength))
                        }
                    }

                Spacer()

                CustomBottomButton(action: {}, label: "저장하기", isFormValid: .constant(!inputRoomName.isEmpty))
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarColor(UIColor(named: "White01"), title: "채팅방 이름 변경")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }
}

#Preview {
    EditChatRoomNameView()
}
