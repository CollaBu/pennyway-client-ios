//
//  ChatMessage.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatMessage

struct ChatMessage: View {
    let content: String
    let createdAt: String
    let isSender: Bool
    let maxWidth: CGFloat = 151 * DynamicSizeFactor.factor()
    @State private var textWidth: CGFloat = .zero
    
    private var parsedSpendings: [SpendingItemToChat] {
        guard let data = content.data(using: .utf8) else {
            return []
        }
        let decodedData = try? JSONDecoder().decode([SpendingItemToChat].self, from: data)
        return decodedData ?? []
    }
    
    var body: some View {
        HStack(spacing: 9) {
            if isSender {
                // 타임스탬프 왼쪽 (isSender가 true일 때)
                Timestamp
            }
            
            if parsedSpendings.isEmpty {
                textChatMessage
            } else {
                shareChatMessage
            }
            
            if !isSender {
                // 타임스탬프 오른쪽 (isSender가 false일 때)
                Timestamp
            }
        }
        .frame(maxWidth: .infinity, alignment: isSender ? .trailing : .leading)
    }
    
    private var Timestamp: some View {
        VStack {
            Spacer()
            if let date = DateFormatterUtil.dateFromString(createdAt) {
                Text(Date.koreanMeridianTimeFormatter(from: date))
                    .font(.B4MediumFont())
                    .platformTextColor(color: Color("Gray05"))
            }
        }
    }
    
    private var textChatMessage: some View {
        ZStack(alignment: .topLeading) {
            Text(content)
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    // Rectangle을 Text의 배경으로 사용
                    Rectangle()
                        .fill(isSender ? Color("Yellow01") : Color("White01"))
                        .cornerRadius(6)
                )
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(key: TextHeightPreferenceKey.self, value: geo.size.height)
                        Color.clear.preference(key: TextWidthPreferenceKey.self, value: geo.size.width)
                    }
                )
                .onPreferenceChange(TextWidthPreferenceKey.self) { width in
                    self.textWidth = width
                }
        }
        .frame(minWidth: textWidth)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var shareChatMessage: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 타이틀 영역
            Text("바다오리님의\n 2024년 8월 23일 지출 내역")
                .font(.B2SemiboldFont())
                .platformTextColor(color: .white01)
                .padding(.leading, 13 * DynamicSizeFactor.factor())
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 52 * DynamicSizeFactor.factor())
                .background(
                    RoundedCornerUtil(radius: 6, corners: [.topLeft, .topRight])
                        .fill(Color(.mint03))
                )
            
            // 지출 목록
            VStack(spacing: 8) {
                ForEach(parsedSpendings, id: \.name) { spending in
                    HStack {
                        if let icon = categoryBaseName(from: spending.icon) {
                            Image("icon_category_\(icon)_on")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23 * DynamicSizeFactor.factor(), height: 23 * DynamicSizeFactor.factor())
                        }
                        
                        Spacer().frame(width: 8 * DynamicSizeFactor.factor())
                        
                        Text(spending.name)
                            .font(.B2SemiboldFont())
                            .platformTextColor(color: .gray06)
                        
                        Spacer()
                        
                        Text("\(spending.amount)원")
                            .font(.B2MediumFont())
                            .platformTextColor(color: .mint03)
                    }
                    .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                }
            }
            
            if parsedSpendings.count >= 4 {
                Button(action: {}) {
                    Text("다른 내역도 확인하기")
                        .font(.B2SemiboldFont())
                        .platformTextColor(color: .gray04)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7 * DynamicSizeFactor.factor())
                        .padding(.horizontal, 22)
                        .background(Color.gray02)
                        .cornerRadius(4)
                }
                .padding(.horizontal, 14 * DynamicSizeFactor.factor())
            }
            
            Spacer().frame(height: 6)
        }
        .background(
            RoundedCornerUtil(radius: 6, corners: [.bottomLeft, .bottomRight])
                .fill(Color(.white01))
        )
        .frame(width: 160 * DynamicSizeFactor.factor())
    }

    func categoryBaseName(from icon: String) -> CategoryBaseName? {
        return SpendingCategoryIconList.allCases.first { $0.rawValue == icon }?.baseName
    }
}

// MARK: - SpendingItemToChat

struct SpendingItemToChat: Codable {
    let isCustom: Bool
    let categoryId: Int
    let name: String
    let icon: String
    let amount: Int
}
