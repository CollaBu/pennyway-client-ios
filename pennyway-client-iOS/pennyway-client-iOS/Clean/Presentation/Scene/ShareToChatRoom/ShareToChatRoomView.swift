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
    
    var body: some View {
        ZStack {
            VStack {
                searchChatContainer
                
//                ForEach(rooms, id: \.id) { chatRoom in
//                    SelectChatRoomCell(chatRoom: chatRoom)
//                        .buttonStyle(PlainButtonStyle())
//                        .buttonStyle(BasicButtonStyleUtil())
//                }
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
            CustomInputView(inputText: $chatRoomName, placeholder: "", onCommit: {}, isSecureText: false, showSearchBtn: true)
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
