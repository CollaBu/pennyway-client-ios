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
    @State private var isFormValid: Bool = false
    @State private var selectedChatRoomIds: [Int64] = []
    private let maxLength = 19

    @Binding var clickDate: Date?
    @StateObject var viewModelWrapper: ShareToChatRoomViewModelWrapper
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack {
                if viewModelWrapper.chatData.isEmpty {
                    Spacer()
                    DefaultChatContent()
                    Spacer()
                } else {
                    Spacer().frame(height: 32 * DynamicSizeFactor.factor())
                    
                    searchChatContainer
                    
                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())
                    
                    ScrollView {
                        ForEach(viewModelWrapper.filteredChatData, id: \.id) { chatRoom in
                            SelectChatRoomCell(selectedChatRoomIds: $selectedChatRoomIds, chatRoom: chatRoom)
                                .buttonStyle(BasicButtonStyleUtil())
                        }
                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    }
                    
                    CustomBottomButton(action: {
                        viewModelWrapper.shareToChatRoomViewModel.shareToChatRoom(date: clickDate, chatRoomIds: selectedChatRoomIds) { success in
                            if success {
                                self.presentationMode.wrappedValue.dismiss()
                                mainTabViewModel.resetSpendingViewAndSwitchToChat()
                            }
                        }
                        
                    }, label: "공유하기", isFormValid: $isFormValid)
                        .padding(.bottom, 34 * DynamicSizeFactor.factor())
                }
            }
        }
        .onChange(of: selectedChatRoomIds) { newValue in
            isFormValid = !newValue.isEmpty // 선택된 항목이 있으면 활성화
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
            CustomInputView(inputText: $chatRoomName, placeholder: "", onCommit: {
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
    @Binding var selectedChatRoomIds: [Int64]
    
    let chatRoom: ChatRoomProtocol
    
    /// selectedChatRoomIds를 기반으로 isSelected를 계산
    private var isSelected: Bool {
        selectedChatRoomIds.contains(chatRoom.id)
    }

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
                                    .platformTextColor(color: Color(.gray04))
                            }
                        }
                        
                        Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                        
                        Text(chatRoom.description)
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color(.gray07))
                        
                        Spacer().frame(height: 3 * DynamicSizeFactor.factor())
                        
                        Text("\(chatRoom.participantCount)명")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color(.gray04))
                            .padding(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                let selected = isSelected == true ? Image(.iconCheckoneOnSmall) : Image(.iconCheckoneOffSmallGray03)

                selected
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 60 * DynamicSizeFactor.factor())
            .background(Color.white)
        }
        .onTapGesture {
            updateSelection()
            Log.debug("\(selectedChatRoomIds)")
        }
        .onAppear {
            loadImage(from: chatRoom.backgroundImageUrl) { image in
                self.loadedImage = image
            }
        }
    }

    private func updateSelection() {
        if isSelected {
            selectedChatRoomIds.removeAll { $0 == chatRoom.id } // 선택 해제
        } else {
            selectedChatRoomIds.append(chatRoom.id) // 선택 추가
        }
    }
}

// MARK: - ShareToChatRoomViewModelWrapper

final class ShareToChatRoomViewModelWrapper: ObservableObject {
    @Published var chatData: [ChatRoomItemModel] = []
    @Published var searchQuery: String = "" // 검색어 추가
 
    var shareToChatRoomViewModel: ShareToChatRoomViewModel
    
    var filteredChatData: [ChatRoomItemModel] {
        if searchQuery.isEmpty {
            return chatData
        } else {
            // title 속성에 검색어가 포함된 항목만 필터링 (대소문자 구분 없이)
            return chatData.filter { $0.title.range(of: searchQuery, options: .caseInsensitive) != nil }
        }
    }
    
    init(shareToChatRoomViewModel: ShareToChatRoomViewModel) {
        self.shareToChatRoomViewModel = shareToChatRoomViewModel
        
        shareToChatRoomViewModel.roomData.observe(on: self) { [weak self] newData in
            self?.chatData = newData
        }
    }
}
