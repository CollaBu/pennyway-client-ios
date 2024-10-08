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
    @State private var textEditorHeight: CGFloat = 14 * DynamicSizeFactor.factor()
    @State private var lineCount: Int = 1

    var body: some View {
        VStack {
            Spacer().frame(height: 11 * DynamicSizeFactor.factor())

            HStack {
                featureButton
                messageInput
                sendButton
            }
            .frame(height: textEditorHeight + 16 * DynamicSizeFactor.factor())
            .background(Color("Gray02"))
            .cornerRadius(15)
            .padding(.horizontal, 16)

            featureContent
        }
        .background(Color("White01"))
    }

    private var featureButton: some View {
        VStack {
            Spacer()
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showFeature.toggle()
                }
            }) {
                Image(showFeature ? "icon_close_filled_gray" : "icon_add_filled_gray")
                    .resizable()
                    .frame(width: 20 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
                    .padding(.leading, 5 * DynamicSizeFactor.factor())
                    .padding(.bottom, 5 * DynamicSizeFactor.factor())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var messageInput: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color("Gray02"))
                .frame(height: textEditorHeight)

            TextEditor(text: $message)
                .frame(height: textEditorHeight)
                .colorMultiply(Color("Gray02"))
                .platformTextColor(color: Color("Gray07"))
                .font(.B2MediumFont())
                .lineLimit(5)
                .onChange(of: message) { newValue in
                    updateTextEditorHeight(text: newValue)
                }

            if message.isEmpty {
                Text("오늘은 어떤 소비를 했나요?")
                    .platformTextColor(color: Color("Gray03"))
                    .font(.B2MediumFont())
                    .padding(.vertical, 8)
            }
        }

        .frame(maxWidth: .infinity)
    }

    private var sendButton: some View {
        VStack {
            Spacer()
            if !message.isEmpty {
                Button(action: {
                    Log.debug("Message sent: \(message)")
                    message = ""
                }) {
                    Image("icon_send_filled_primary")
                        .resizable()
                        .frame(width: 20 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
                        .padding(.trailing, 5 * DynamicSizeFactor.factor())
                        .padding(.bottom, 5 * DynamicSizeFactor.factor())
                }
                .transition(.opacity)
                .animation(.easeInOut, value: message.isEmpty)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var featureContent: some View {
        Group {
            if showFeature {
                Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                VStack(spacing: 7 * DynamicSizeFactor.factor()) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 37 * DynamicSizeFactor.factor(), height: 37 * DynamicSizeFactor.factor())

                    Text("사진")
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B2MediumFont())
                }
                Spacer().frame(height: 20 * DynamicSizeFactor.factor())
            } else {
                Spacer().frame(height: 19 * DynamicSizeFactor.factor())
            }
        }
    }

    /// 엔터키 누른 걸 감지해서 라인 수에 따른 높이 조절 메서드
    private func updateTextEditorHeight(text: String) {
        let newLineCount = text.components(separatedBy: .newlines).count
        if newLineCount != lineCount {
            let heightDifference = (newLineCount - lineCount) * Int(14 * DynamicSizeFactor.factor())

            if textEditorHeight <= 14 * DynamicSizeFactor.factor() * 5 {
                textEditorHeight += CGFloat(heightDifference)
                lineCount = newLineCount
            }
        }
    }
}

#Preview {
    ChatBottomBar()
}
