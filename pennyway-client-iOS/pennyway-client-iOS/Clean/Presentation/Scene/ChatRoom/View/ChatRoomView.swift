//
//  ChatRoomView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatRoomView

struct ChatRoomView: View {
    @StateObject private var keyboardManager = KeyboardManager()
    @State private var isSideMenuPresented = false
    @EnvironmentObject var viewStateManager: ViewStateManager
    @EnvironmentObject var viewModelWrapper: ChatRoomViewModelWrapper
    @State private var isNavigateToMyChat = false
    @ObservedObject var chatViewModelWrapper: ChatViewModelWrapper

    var chatRoom: ChatRoomProtocol
    private let currentUserId = getUserData()!.id

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    ChatContent(chats: viewModelWrapper.messageData, members: viewModelWrapper.chatUserData, currentUserId: currentUserId, keyboardManager: keyboardManager)
                        .frame(height: geometry.size.height - keyboardManager.keyboardHeight) // ChatContent의 높이를 키보드 높이만큼 조정
                }

                ChatBottomBar()
                    .offset(y: -keyboardManager.keyboardHeight)
                    .animation(keyboardManager.keyboardHeight > 0 ? .easeOut(duration: 0.5) : nil, value: keyboardManager.keyboardHeight)
            }
            .navigationBarColor(UIColor(named: "Ashblue02"), title: "\(chatRoom.title)")
            .background(Color("Ashblue02"))
            .setTabBarVisibility(isHidden: true)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            UIApplication.shouldDismissKeyboard = true
                            isNavigateToMyChat = true
                            viewModelWrapper.chatRoomViewModel.reset()
                        }, label: {
                            Image("icon_arrow_back")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 34)
                                .padding(5)
                        })
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                    }.offset(x: -10)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                UIApplication.shouldDismissKeyboard = true
                                isSideMenuPresented.toggle()
                            }
                        }, label: {
                            Image("icon_navigationbar_kebabmenu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }.offset(x: 10)
                }
            }
            .onAppear {
                viewStateManager.setCurrentView(self)
                viewModelWrapper.chatRoomViewModel.roomData.value = chatRoom // 현재 채팅방 정보 저장

                // 채팅방 상세 정보 조회
                viewModelWrapper.chatRoomViewModel.getChatRoomDetail(chatRoomId: Int64(chatRoom.id))
                viewModelWrapper.chatRoomViewModel.subscribeToNotifications()
            }

            ZStack {
                if isSideMenuPresented {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isSideMenuPresented = false
                            }
                        }
                    ChatSideMenuView()
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isSideMenuPresented)

            NavigationLink(destination: ChatCellView(viewModelWrapper: chatViewModelWrapper), isActive: $isNavigateToMyChat) {}
                .hidden()
        }
    }
}

// MARK: - ChatRoomViewModelWrapper

final class ChatRoomViewModelWrapper: ObservableObject {
    @Published var roomData: ChatRoomProtocol? = nil
    @Published var roomDetailData: ChatRoomDetailItemModel? = nil
    @Published var messageData: [MessageItemModel] = []
    @Published var chatUserData: [ChatMemberItemModel] = []
    @Published var previousMessageData: PreviousMessage? = nil

    var chatRoomViewModel: any ChatRoomViewModel

    init(chatRoomViewModel: any ChatRoomViewModel) {
        self.chatRoomViewModel = chatRoomViewModel

        roomData = chatRoomViewModel.roomData.value
        roomDetailData = chatRoomViewModel.roomDetailData.value
        messageData = chatRoomViewModel.messageData.value
        chatUserData = chatRoomViewModel.chatUserData.value
        previousMessageData = chatRoomViewModel.previousMessageData.value

        chatRoomViewModel.roomData.observe(on: self) { [weak self] newData in
            self?.roomData = newData
        }

        chatRoomViewModel.roomDetailData.observe(on: self) { [weak self] newData in
            self?.roomDetailData = newData
        }

        chatRoomViewModel.messageData.observe(on: self) { [weak self] newData in
            self?.messageData = newData
        }

        chatRoomViewModel.chatUserData.observe(on: self) { [weak self] newData in
            self?.chatUserData = newData
        }

        chatRoomViewModel.previousMessageData.observe(on: self) { [weak self] newData in
            self?.previousMessageData = newData
        }
    }
}
