//
//  ChatMessage.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatMessage

struct ChatMessage: View {
    let chat: MessageItemModel
    let sender: ChatMemberItemModel
    let isSender: Bool
    let maxWidth: CGFloat = 151 * DynamicSizeFactor.factor()
    
    @State private var isNavigateToShareView = false
    @State private var textWidth: CGFloat = .zero
    
    private var spendingContent: SpendingContent? { // 총 지출 내역 정보
        guard let data = chat.content.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(SpendingContent.self, from: data)
    }

    private var parsedSpendings: [SpendingItemToChat] { // 지출 내역 리스트
        return spendingContent?.spendingOnDates ?? []
    }
    
    var body: some View {
        HStack(spacing: 9) {
            if isSender {
                // 타임스탬프 왼쪽 (isSender가 true일 때)
                Timestamp
            }
            
            if chat.categoryType != .share {
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
        
        NavigationLink(destination: ShareSpendingListView(spendings: parsedSpendings), isActive: $isNavigateToShareView) {}
            .hidden()
    }
    
    private var Timestamp: some View {
        VStack {
            Spacer()
            if let date = DateFormatterUtil.dateFromString(chat.createdAt) {
                Text(Date.koreanMeridianTimeFormatter(from: date))
                    .font(.B4MediumFont())
                    .platformTextColor(color: Color("Gray05"))
            }
        }
    }
    
    private var textChatMessage: some View {
        ZStack(alignment: .topLeading) {
            Text(chat.content)
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
        VStack(spacing: 12) {
            // 타이틀 영역
            Text("\(sender.name)님의\n\(DateFormatterUtil.formatNormalDateString(spendingContent?.date ?? "")) 지출 내역")
                .font(.B2SemiboldFont())
                .platformTextColor(color: .white01)
                .padding(.leading, 13 * DynamicSizeFactor.factor())
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 52 * DynamicSizeFactor.factor())
                .background(
                    RoundedCornerUtil(radius: 6, corners: [.topLeft, .topRight])
                        .fill(Color(.mint03))
                )
            
            if parsedSpendings.isEmpty {
                Image("icon_share_feed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 102 * DynamicSizeFactor.factor(), height: 100 * DynamicSizeFactor.factor())
                Spacer().frame(height: 12)
            } else {
                // 지출 목록
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(parsedSpendings.prefix(3), id: \.name) { spending in
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
                    Button(action: {
                        isNavigateToShareView = true
                    }) {
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
        }
        .background(
            RoundedCornerUtil(radius: 6, corners: [.bottomLeft, .bottomRight])
                .fill(Color(.white01))
        )
        .frame(width: 160 * DynamicSizeFactor.factor())
    }

    private func categoryBaseName(from icon: String) -> CategoryBaseName? {
        return SpendingCategoryIconList.allCases.first { $0.rawValue == icon }?.baseName
    }
}

// MARK: - SpendingContent

struct SpendingContent: Codable {
    let date: String
    let spendingOnDates: [SpendingItemToChat]
}

// MARK: - SpendingItemToChat

struct SpendingItemToChat: Codable {
    let isCustom: Bool
    let categoryId: Int
    let name: String
    let icon: String
    let amount: Int
}
