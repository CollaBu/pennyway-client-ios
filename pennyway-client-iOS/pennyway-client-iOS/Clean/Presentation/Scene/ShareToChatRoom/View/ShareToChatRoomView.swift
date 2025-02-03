//
//  ShareToChatRoomView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 2/4/25.
//

import SwiftUI

// MARK: - ShareToChatRoomView

struct ShareToChatRoomView: View {
    @State private var chatRoomName: String = ""
    private let maxLength = 19

    @ObservedObject var viewModelWrapper: ShareToChatRoomViewModelWrapper

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 32 * DynamicSizeFactor.factor())
                
                if viewModelWrapper.chatData.isEmpty {
                    Spacer()
                    DefaultChatContent()
                    Spacer()
                } else {
                    Spacer()
                    
                    searchChatContainer
                    
                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())
                    
                    ScrollView {
                        ForEach(viewModelWrapper.filteredChatData, id: \.id) { chatRoom in
                            SelectChatRoomCell(chatRoom: chatRoom)
                                .buttonStyle(BasicButtonStyleUtil()) // 중복 제거
                        }
                    }
                }
            }
        }
        .onAppear {
            // 뷰에 진입하자마자 내채팅 조회 api 호출
            viewModelWrapper.shareToChatRoomViewModel.getChatRoom { success in
                if success {
                    Log.debug("[ShareToChatRoomView] onAppear: 내채팅 조회 api 호출")
                }
            }
        }
        .navigationBarColor(UIColor(named: "White01"), title: "내 채팅")
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .background(Color(.white01))
        .edgesIgnoringSafeArea(.bottom)
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
    
    private var searchChatContainer: some View {
        VStack {
            CustomInputView(inputText: $chatRoomName, placeholder: "원하는 주제를 찾아보세요", onCommit: {
                viewModelWrapper.searchQuery = chatRoomName
            }, isSecureText: false, showSearchBtn: true)
                .onChange(of: chatRoomName) { newValue in
                    if newValue.count > maxLength {
                        chatRoomName = String(chatRoomName.suffix(19))
                    }
                }
        }
    }
}

// MARK: - SelectChatRoomCell

struct SelectChatRoomCell: View, ImageLoadable {
    @State private var loadedImage: UIImage? = nil
    
    let chatRoom: ChatRoomProtocol
    
    var body: some View {
        ZStack {
            HStack(spacing: 13) {
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 43 * DynamicSizeFactor.factor(), height: 43 * DynamicSizeFactor.factor())
                        .cornerRadius(8)
                } else {
                    Image(.iconIllustChatNoPicture)
                        .resizable()
                        .frame(width: 43 * DynamicSizeFactor.factor(), height: 43 * DynamicSizeFactor.factor())
                        .cornerRadius(8)
                }
                
                ZStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 4 * DynamicSizeFactor.factor()) {
                            Text(chatRoom.title)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Gray07"))
                            
                            if chatRoom.isPrivate {
                                Image(.iconLock)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 9 * DynamicSizeFactor.factor(), height: 11.3 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: Color("Gray04"))
                            }
                        }
                        
                        Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                        
                        Text(chatRoom.description)
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                        
                        Spacer().frame(height: 3 * DynamicSizeFactor.factor())
                        
                        Text("\(chatRoom.participantCount)명")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                            .padding(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 60 * DynamicSizeFactor.factor())
            .background(Color.white)
        }
        .onAppear {
            loadImage(from: chatRoom.backgroundImageUrl) { image in
                self.loadedImage = image
            }
        }
    }
}

// MARK: - ShareToChatRoomViewModelWrapper

final class ShareToChatRoomViewModelWrapper: ObservableObject {
    @Published var chatData: [ChatRoomItemModel] = []
    @Published var searchQuery: String = "" // 검색어 추가
 
    var shareToChatRoomViewModel: DefaultShareToChatRoomViewModel
    
    var filteredChatData: [ChatRoomItemModel] {
        if searchQuery.isEmpty {
            return chatData
        } else {
            // title 속성에 검색어가 포함된 항목만 필터링 (대소문자 구분 없이)
            return chatData.filter { $0.title.range(of: searchQuery, options: .caseInsensitive) != nil }
        }
    }
    
    init(shareToChatRoomViewModel: DefaultShareToChatRoomViewModel) {
        self.shareToChatRoomViewModel = shareToChatRoomViewModel
        
        shareToChatRoomViewModel.roomData.observe(on: self) { [weak self] newData in
            self?.chatData = newData
        }
    }
}
