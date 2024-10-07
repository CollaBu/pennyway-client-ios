//
//  ChatBottomBar.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatBottomBar: View {
    @State private var message: String = ""
    @State private var showFeature: Bool = false

    var body: some View {
        VStack {
            Spacer().frame(height: 11 * DynamicSizeFactor.factor())

            HStack {
                Button(action: {
                    showFeature.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 20 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
                        .padding(.leading, 6 * DynamicSizeFactor.factor())
                }).buttonStyle(PlainButtonStyle())

                ZStack(alignment: .leading) {
                    if message.isEmpty {
                        Text("오늘은 어떤 소비를 했나요?")
                            .platformTextColor(color: Color("Gray03"))
                            .font(.B2MediumFont())
                    }
                    TextField("", text: $message)
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B2MediumFont())

                }.frame(maxWidth: .infinity)

                if !message.isEmpty {
                    Button(action: {
                        Log.debug("Message sent: \(message)")
                        message = ""
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 20 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
                            .padding(.trailing, 6 * DynamicSizeFactor.factor())
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: message.isEmpty)
                }
            }
            .frame(height: 29 * DynamicSizeFactor.factor())
            .background(Color("Gray02"))
            .cornerRadius(28)
            .padding(.horizontal, 16)

            if showFeature {
                Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                VStack {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 37 * DynamicSizeFactor.factor(), height: 37 * DynamicSizeFactor.factor())

                    Text("사진")
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B2MediumFont())
                }
            }

        }.background(Color("White01"))
    }
}

#Preview {
    ChatBottomBar()
}
