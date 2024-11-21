//
//  ChatContent.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatContent: View {
    let chats: [MessageItemModel]
    let members: [ChatMemberItemModel]
    let currentUserId: Int64

    @State private var isLoadingViewShown: Bool = false
    @State private var isReloadViewShown: Bool = false
    @State private var animateLoadingView: Bool = false
    @State private var scrollToTop: Bool = false // 위쪽으로 스크롤 했는지 여부

    @ObservedObject var keyboardManager: KeyboardManager
    @EnvironmentObject var viewModelWrapper: ChatRoomViewModelWrapper

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 14 * DynamicSizeFactor.factor()) {
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                // 스크롤 뷰가 가장 위쪽에 도달했을 때 getPreviousChat 호출
                                if geometry.frame(in: .global).minY >= 0 {
                                    scrollToTop = true

                                    // previousMessageData가 nil일 경우 또는 hasNext가 true인 경우에만 채팅을 불러옴
                                    if viewModelWrapper.previousMessageData == nil || (viewModelWrapper.previousMessageData?.hasNext == true) {
                                        self.loadPreviousChat()
                                    }
                                }
                            }
                            .onDisappear {
                                scrollToTop = false
                            }
                    }
                    .frame(height: 1)

                    if isLoadingViewShown {
                        LoadingView(startAnimate: $animateLoadingView)
                    }

                    if isReloadViewShown {
                        ReloadView(action: retryLoadPreviousChat)
                    }

                    ForEach(groupedChatsByDate.keys.sorted(), id: \.self) { date in
                        Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                        Section(header: ChatHeader(data: date)) {
                            Spacer().frame(height: 3)

                            ForEach(groupedChatsByDate[date] ?? []) { chat in
                                if let sender = members.first(where: { $0.userId == chat.senderId }) {
                                    if chat.senderId == currentUserId {
                                        ChatSendCell(chat: chat, sender: sender)
                                    } else {
                                        ChatReceiveCell(chat: chat, sender: sender)
                                    }
                                } else {
                                    Spacer().frame(height: 3)

                                    if chat.categoryType == CategoryType.system {
                                        ChatHeader(data: chat.content)
                                    }
                                }
                            }
                        }
                    }

                    // ScrollView 하단에 있는 마지막 아이템을 위한 태그
                    Spacer().frame(height: 5 * DynamicSizeFactor.factor())
                        .id("bottom")
                }
            }
            .onChange(of: chats) { _ in
                if !scrollToTop {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            .onChange(of: keyboardManager.keyboardHeight) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .onAppear {
                // 처음 열릴 때 가장 아래로 스크롤
                proxy.scrollTo("bottom", anchor: .bottom)
            }
            .onTapGesture {
                UIApplication.shouldDismissKeyboard = true // 빈 화면 터치 시 키보드 닫기
            }
        }
    }

    private var groupedChatsByDate: [String: [MessageItemModel]] {
        let formatter = Date.chatDateFormatter()
        let grouped = Dictionary(grouping: chats) { chat -> String in
            if let date = DateFormatterUtil.dateFromString(chat.createdAt) {
                return formatter.string(from: date)
            }
            return ""
        }

        // 각 날짜별 메시지 배열을 오래된순으로 저장
        return grouped.mapValues { $0.reversed() }
    }

    private func loadPreviousChat() {
        // LoadingView를 표시하고, 10초 후에 ReloadView를 표시할 타이머 설정
        isLoadingViewShown = true
        isReloadViewShown = false

        var retryWorkItem: DispatchWorkItem

        retryWorkItem = DispatchWorkItem {
            Log.debug("API 응답이 10초 이상 걸림")

            // 로딩 뷰 사라지고, 재로드 뷰 나타남
            animateLoadingView = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLoadingViewShown = false
                isReloadViewShown = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: retryWorkItem)

        // 10초가 지나기 전에 API가 성공하면 타이머 취소
        viewModelWrapper.chatRoomViewModel.getPreviousChat { result in
            switch result {
            case .success:
                // 로딩 뷰와 재로드 뷰 사라짐
                animateLoadingView = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isLoadingViewShown = false
                    isReloadViewShown = false
                }
            case .failure:
                // 로딩 뷰 사라지고, 재로드 뷰 나타남
                animateLoadingView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isLoadingViewShown = false
                    isReloadViewShown = true
                }
            }
            retryWorkItem.cancel()
        }
    }

    private func retryLoadPreviousChat() {
        // ReloadView가 클릭되었을 때 다시 데이터를 요청하는 함수
        isLoadingViewShown = true
        isReloadViewShown = false

        // getPreviousChat 다시 호출
        viewModelWrapper.chatRoomViewModel.getPreviousChat { result in
            switch result {
            case .success:
                // 데이터가 성공적으로 로드되었으면 LoadingView 숨김
                self.isLoadingViewShown = false
            case .failure:
                // 실패 시에도 LoadingView 숨김
                self.isLoadingViewShown = false
                self.isReloadViewShown = true
            }
        }
    }
}
