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

    private let minHeight: CGFloat = 15 * DynamicSizeFactor.factor()
    private let maxHeight: CGFloat = 14 * DynamicSizeFactor.factor() * 3
    private let maxLineCount: Int = 3

    private var newLineCount: Int {
        message.components(separatedBy: "\n").count
    }

    private var autoLineCount: Int {
        var counter: Int = 0

        guard maxTextWidth > 0 else {
            Log.error("maxTextWidth is zero or invalid")
            return 0
        }

        for line in message.components(separatedBy: "\n") {
            let currentTextWidth = calculateTextWidth(for: line, fontSize: minHeight)

            if currentTextWidth > 0 {
                counter += Int(currentTextWidth / maxTextWidth)
                Log.debug("width : \(Int(currentTextWidth / maxTextWidth)), \(currentTextWidth), \(maxTextWidth)")
            } else {
                Log.error("currentTextWidth is invalid or zero for line: \(line)")
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
            .background(Color("Gray02"))
            .cornerRadius(15 * DynamicSizeFactor.factor())
            .padding(.horizontal, 16)

            FeatureContent
        }
        .background(Color("White01"))
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
                    .colorMultiply(Color("Gray02"))
                    .font(.B2MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                    .frame(height: currentTextEditorHeight)
                    .TextAutocapitalization()
                    .AutoCorrectionExtensions()
                    .onAppear {
                        setMaxTextWidth(proxy: proxy)
                    }
                    .onChange(of: message) { _ in
                        updateTextEditorCurrentHeight()
                    }
                    .padding(.trailing, 19)

                if message.isEmpty {
                    Text("오늘은 어떤 소비를 했나요?")
                        .platformTextColor(color: Color("Gray03"))
                        .font(.B2MediumFont())
                        .padding(.leading, 4)
                }
            }
            .padding(.vertical, 8)
            .border(.ashblue01)
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
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B2MediumFont())
                }
                Spacer().frame(height: 20 * DynamicSizeFactor.factor())
            } else {
                Spacer().frame(height: 19 * DynamicSizeFactor.factor())
            }
        }
    }

    private func calculateTextWidth(for text: String, fontSize: CGFloat) -> CGFloat {
        guard !text.isEmpty else {
            Log.error("Text is empty, returning 0 width.")
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

    private func setMaxTextWidth(proxy: GeometryProxy) {
        DispatchQueue.main.async {
            self.maxTextWidth = proxy.size.width + 30
        }
    }

    private func updateTextEditorCurrentHeight() {
        let totalLineCount = newLineCount + autoLineCount

        let currentHeight = (CGFloat(totalLineCount) * minHeight)
        currentTextEditorHeight = min(max(currentHeight, minHeight), maxHeight)
    }
}

#Preview {
    ChatBottomBar()
}
