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
    @State private var currentTextEditorHeight: CGFloat = 14 * DynamicSizeFactor.factor()
    @State private var maxTextWidth: CGFloat = 0

    // TextEditor의 최소, 최대 높이 정의
    private let minHeight: CGFloat = 15 * DynamicSizeFactor.factor() // 최소 높이
    private let maxHeight: CGFloat = 14 * DynamicSizeFactor.factor() * 3 // 최대 높이 (3줄)
    private let maxLineCount: Int = 3 // 최대 줄 수

    /// 현재 메시지에서 줄바꿈(\n)으로 구분된 줄의 수 계산
    private var newLineCount: Int {
        message.components(separatedBy: "\n").count
    }

    /// 텍스트 자동 줄바꿈으로 인한 줄 수 계산
    private var autoLineCount: Int {
        var counter: Int = 0

        guard maxTextWidth > 0 else {
            Log.error("maxTextWidth가 0이거나 유효하지 않음")
            return 0
        }

        // 각 줄의 텍스트 너비 계산하여 줄 수 증가
        for line in message.components(separatedBy: "\n") {
            let currentTextWidth = calculateTextWidth(for: line, fontSize: minHeight)

            if currentTextWidth > 0 {
                counter += Int(currentTextWidth / maxTextWidth)
            } else {
                Log.error("라인의 텍스트 너비가 유효하지 않거나 0: \(line)")
            }
        }

        return counter
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 11 * DynamicSizeFactor.factor())

            HStack(spacing: 4) {
                FeatureButton
                MessageInput
                SendButton
            }
            .frame(height: currentTextEditorHeight + 16)
            .background(Color(.gray02))
            .cornerRadius(15 * DynamicSizeFactor.factor())
            .padding(.horizontal, 16)

            FeatureContent
        }
        .background(Color(.white01))
    }

    private var FeatureButton: some View {
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
                    .padding(.leading, 5)
                    .padding(.bottom, 8)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var MessageInput: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                TextEditor(text: $message)
                    .colorMultiply(Color(.gray02))
                    .font(.B2MediumFont())
                    .platformTextColor(color: Color(.gray07))
                    .frame(height: currentTextEditorHeight)
                    .TextAutocapitalization()
                    .AutoCorrectionExtensions()
                    .onAppear {
                        setMaxTextWidth(proxy: proxy) // 최대 텍스트 너비 설정
                    }
                    .onChange(of: message) { _ in
                        updateTextEditorCurrentHeight() // 메시지 변경 시 TextEditor 높이 업데이트
                    }
                    .padding(.trailing, 19)

                if message.isEmpty {
                    Text("오늘은 어떤 소비를 했나요?")
                        .platformTextColor(color: Color(.gray03))
                        .font(.B2MediumFont())
                        .padding(.leading, 4)
                        .allowsHitTesting(false)
                }
            }
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var SendButton: some View {
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
                        .padding(.trailing, 5)
                        .padding(.bottom, 8)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: message.isEmpty)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var FeatureContent: some View {
        Group {
            if showFeature {
                Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                VStack(spacing: 7 * DynamicSizeFactor.factor()) {
                    Image("icon_chat_image")
                        .resizable()
                        .frame(width: 37 * DynamicSizeFactor.factor(), height: 37 * DynamicSizeFactor.factor())

                    Text("사진")
                        .platformTextColor(color: Color(.gray07))
                        .font(.B2MediumFont())
                }
                Spacer().frame(height: 20 * DynamicSizeFactor.factor())
            } else {
                Spacer().frame(height: 19 * DynamicSizeFactor.factor())
            }
        }
    }

    /// 텍스트의 너비 계산
    private func calculateTextWidth(for text: String, fontSize: CGFloat) -> CGFloat {
        guard !text.isEmpty else {
            Log.debug("텍스트가 비어있어서 너비는 0")
            return 0
        }

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize)
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)

        let textBoundingSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

        let textRect = attributedString.boundingRect(
            with: textBoundingSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return textRect.width
    }

    /// GeometryReader를 사용하여 최대 텍스트 너비 설정
    private func setMaxTextWidth(proxy: GeometryProxy) {
        DispatchQueue.main.async {
            self.maxTextWidth = proxy.size.width + 30
        }
    }

    /// TextEditor의 현재 높이 업데이트
    private func updateTextEditorCurrentHeight() {
        let totalLineCount = newLineCount + autoLineCount

        let currentHeight = (CGFloat(totalLineCount) * minHeight)
        currentTextEditorHeight = min(max(currentHeight, minHeight), maxHeight)
    }
}

#Preview {
    ChatBottomBar()
}
