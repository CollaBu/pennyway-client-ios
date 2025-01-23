import SwiftUI

// MARK: - ChatCellView

struct ChatCellView: View {
    @State private var selectedTab: Int = 1
    @State private var chatRoomName: String = "" // 수정 예정
    @State var isNavigateToMakeChatRoom = false
    @State private var isCheckMarkVisible = false // 체크 표시를 보여줄지 여부
    @State private var isPopUp = false // 채팅방 나가기 팝업 표시 여부
    @State private var isErrorPopUp = false // 검색뷰에서 특정 글자 수 이하인 경우 나오는 팝업 표시 여부
    @State private var selectedChatRoom: ChatRoomItemModel? = nil // 내 채팅에서 어떤 채팅방이 선택됐는지의 여부
    @State private var selectedSearchChatRoom: SearchChatRoomItemModel? = nil // 검색된 채팅방 중 어떤 채팅방이 선택됐는지의 여부
    @State private var isNavigateChatRoomDetailView = false // 채팅방 참여뷰로 이동하기 위한 변수
    @EnvironmentObject var viewStateManager: ViewStateManager
    @ObservedObject var viewModelWrapper: ChatViewModelWrapper
    @EnvironmentObject var chatRoomViewModelWrapper: ChatRoomViewModelWrapper

    private let maxLength = 19
    
    var body: some View {
        NavigationAvailable {
            ZStack {
                VStack {
                    Spacer().frame(height: 38 * DynamicSizeFactor.factor())
                        
                    HStack(spacing: 30) {
                        Button(action: {
                            selectedTab = 1
                        }, label: {
                            MyChatContainer
                        })
                        Button(action: {
                            selectedTab = 2
                        }, label: {
                            RecommendChatContainer
                        })
                    }
                        
                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())
                        
                    // 내 채팅에서 채팅방의 존재 유무에 따라 다른 뷰를 보여주도록 함
                    if selectedTab == 1 {
                        if viewModelWrapper.chatData.isEmpty {
                            DefaultChatContent()
                            Spacer()
                        } else {
                            searchChatContainer
                            ChatRoomContent(isNavigateChatRoomDetailView: $isNavigateChatRoomDetailView, isPopUp: $isPopUp, selectedChatRoom: $selectedChatRoom, selectedSearchChatRoom: $selectedSearchChatRoom, dummyChatRooms: .constant(viewModelWrapper.filteredChatData), searchChatRooms: [], isMyChat: true, target: chatRoomName, viewModelWrapper: viewModelWrapper)
                        }
                    } else {
                        searchChatContainer
                        Spacer()
                        ChatRoomContent(isNavigateChatRoomDetailView: $isNavigateChatRoomDetailView, isPopUp: $isPopUp, selectedChatRoom: $selectedChatRoom, selectedSearchChatRoom: $selectedSearchChatRoom, dummyChatRooms: .constant(nil), searchChatRooms: viewModelWrapper.searchChatData, isMyChat: false, target: chatRoomName, viewModelWrapper: viewModelWrapper)
                    }
                }
                    
                if isCheckMarkVisible {
                    Image("icon_illust_completion")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 68 * DynamicSizeFactor.factor(), height: 68 * DynamicSizeFactor.factor())
                        .zIndex(1)
                }
                
                if isPopUp, let chatRoom = selectedChatRoom {
                    CustomPopUpView(
                        showingPopUp: $isPopUp,
                        titleLabel: "채팅방 나가기",
                        subTitleLabel: "선택한 채팅방에서 나갈까요?",
                        firstBtnAction: { self.isPopUp = false },
                        firstBtnLabel: "취소",
                        secondBtnAction: {
                            isPopUp = false
                            deleteChatRoom()
                        },
                        secondBtnLabel: "나가기",
                        secondBtnColor: Color("Red03"))
                }
                
                if chatRoomViewModelWrapper.showErrorPopUp {
//                                        ZStack {
                    ErrorCodePopUpView(showingPopUp: $chatRoomViewModelWrapper.showErrorPopUp, titleLabel: "채팅방을 나갈 수 없어요", subLabel: "방장 권한을 넘긴 후 다시 시도해주세요")
//                            .edgesIgnoringSafeArea(.vertical)
                    // }
                }
                
                if isErrorPopUp {
                    ErrorCodePopUpView(showingPopUp: $isErrorPopUp, titleLabel: "두 글자 이상 입력해주세요", subLabel: "검색은 두 글자부터 가능해요")
                }
                    
                NavigationLink(destination: MakeChatRoomView(chatViewModelWrapper: viewModelWrapper), isActive: $isNavigateToMakeChatRoom) {}
                    .hidden()
                    
                NavigationLink(destination: ChatRoomDetailView(chatRoom: selectedSearchChatRoom, viewModelWrapper: viewModelWrapper), isActive: $isNavigateChatRoomDetailView) {}
                    .hidden()
            }
            .setTabBarVisibility(isHidden: false)
            .navigationTitle(Text("채팅방"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            isNavigateToMakeChatRoom = true
                        }, label: {
                            Image("icon_navigationbar_mint")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        })
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                }
            }
            .onDisappear {
                viewModelWrapper.searchChatData = []
                viewModelWrapper.getChatRoomViewModel.initSearch()
                viewModelWrapper.getChatRoomViewModel.unsubscribeFromNotifications()
                viewModelWrapper.searchQuery = ""
                chatRoomName = ""
            }
            .onAppear {
                // 뷰에 진입하자마자 내채팅 조회 api 호출
                viewModelWrapper.getChatRoomViewModel.getChatRoom { success in
                    if success {
                        Log.debug("[ChatCellView] onAppear: 내채팅 조회 api 호출")
                    }
                }
                viewStateManager.setCurrentView(self, selectedTab: selectedTab)
                viewModelWrapper.getChatRoomViewModel.subscribeToNotifications()
                
                // 검색어 초기화하여 전체 목록 표시
                viewModelWrapper.searchChatData = []
                viewModelWrapper.getChatRoomViewModel.initSearch()
                viewModelWrapper.searchQuery = ""
                chatRoomName = ""
            }
            .onChange(of: selectedTab) { newSelected in
                viewStateManager.setCurrentView(self, selectedTab: newSelected)
            }
            .onChange(of: chatRoomViewModelWrapper.isDeleteSuccess) { _ in
                isPopUp = false
                showCheckMarkAnimation()
            }
        }
    }
    
    private func deleteChatRoom() {
        chatRoomViewModelWrapper.chatRoomViewModel.deleteChatRoom(chatRoomId: selectedChatRoom?.id ?? 0) { success in
            if success {
                Log.debug("[ChatCellView]: 채팅방 나가기 성공")
            } else {
                Log.debug("[ChatCellView]: 채팅방 나가기 실패")
            }
        }
    }
    
    private func showCheckMarkAnimation() {
        withAnimation {
            isCheckMarkVisible = true
        }
        
        viewModelWrapper.getChatRoomViewModel.getChatRoom { success in
            if success {
                isCheckMarkVisible = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isCheckMarkVisible = false
        }
    }
    
    private var searchChatContainer: some View {
        VStack {
            CustomInputView(inputText: $chatRoomName, placeholder: "원하는 주제를 찾아보세요", onCommit: {
                if selectedTab == 2 {
                    // 추천채팅 탭이며 검색어가 2자 이상인 경우만 채팅 검색 api 호출
                    if chatRoomName.count >= 2 {
                        viewModelWrapper.getChatRoomViewModel.initSearch()
                        viewModelWrapper.updateSearchQuery(chatRoomName)

                    } else {
                        isErrorPopUp = true
                        Log.debug("isErrorPopUp:\(isErrorPopUp)")
                    }
                    
                } else {
                    // 내 채팅인 경우
                    viewModelWrapper.searchQuery = chatRoomName
                }
                
            }, isSecureText: false, showSearchBtn: true)
                .onChange(of: chatRoomName) { newValue in
                    if newValue.count > maxLength {
                        chatRoomName = String(chatRoomName.suffix(19))
                    }
                }
            Spacer().frame(height: 23 * DynamicSizeFactor.factor())
        }
        .onAppear {
            // 탭이 전환될 때마다 검색어를 초기화 시킴
            viewModelWrapper.searchQuery = ""
            chatRoomName = ""
        }
    }
    
    private var MyChatContainer: some View {
        VStack {
            if selectedTab == 1 {
                ZStack {
                    // TODO: 읽지 않은 채팅이 존재하는 경우에만 Circle이 표시되도록 추후 수정 필요
                    Circle()
                        .platformTextColor(color: Color("Mint03"))
                        .frame(width: 7 * DynamicSizeFactor.factor(), height: 7 * DynamicSizeFactor.factor())
                        .offset(x: 32 * DynamicSizeFactor.factor(), y: -16 * DynamicSizeFactor.factor())
                    VStack {
                        Text("내 채팅")
                            .font(.ButtonH4SemiboldFont())
                            .platformTextColor(color: Color("Mint03"))
                        Capsule()
                            .platformTextColor(color: Color("Mint03"))
                            .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                            .padding(.top, 4)
                    }
                }
            } else {
                Text("내 채팅")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))
                Capsule()
                    .fill(Color.clear)
                    .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                    .padding(.top, 4)
            }
        }
        .contentShape(Rectangle())
    }
    
    private var RecommendChatContainer: some View {
        VStack {
            if selectedTab == 2 {
                ZStack {
                    VStack {
                        Text("추천 채팅")
                            .font(.ButtonH4SemiboldFont())
                            .platformTextColor(color: Color("Mint03"))
                        Capsule()
                            .platformTextColor(color: Color("Mint03"))
                            .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                            .padding(.top, 4)
                    }
                }
            } else {
                Text("추천 채팅")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))
                Capsule()
                    .fill(Color.clear)
                    .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                    .padding(.top, 4)
            }
        }
        .contentShape(Rectangle())
    }
}

// MARK: - ChatViewModelWrapper

final class ChatViewModelWrapper: ObservableObject {
    @Published var chatData: [ChatRoomItemModel] = []
    @Published var searchChatData: [SearchChatRoomItemModel] = []
    @Published var searchQuery: String = "" // 검색어 추가
    @Published var isPopUp: Bool = false
    
    var makeChatViewModel: any MakeChatRoomViewModel
    var getChatRoomViewModel: any GetChatRoomViewModel
    var joinChatRoomViewModel: any JoinChatRoomViewModel
    var chatRoomViewModel: any ChatRoomViewModel
    
    var filteredChatData: [ChatRoomItemModel] {
        if searchQuery.isEmpty {
            return chatData
        } else {
            // title 속성에 검색어가 포함된 항목만 필터링 (대소문자 구분 없이)
            return chatData.filter { $0.title.range(of: searchQuery, options: .caseInsensitive) != nil }
        }
    }
    
    init(makeChatViewModel: any MakeChatRoomViewModel, getChatRoomViewModel: any GetChatRoomViewModel, chatRoomViewModel: any ChatRoomViewModel, joinChatRoomViewModel: any JoinChatRoomViewModel) {
        self.makeChatViewModel = makeChatViewModel
        self.getChatRoomViewModel = getChatRoomViewModel
        self.chatRoomViewModel = chatRoomViewModel
        self.joinChatRoomViewModel = joinChatRoomViewModel

        chatData = getChatRoomViewModel.roomData.value
        
        getChatRoomViewModel.roomData.observe(on: self) { [weak self] newData in
            self?.chatData = newData
        }
        
        getChatRoomViewModel.searchRoomData.observe(on: self) { [weak self] newData in
            self?.searchChatData = newData
        }
        
        chatRoomViewModel.isDeleteSuccessful.observe(on: self) { [weak self] newData in
            self?.isPopUp = newData
        }
    }
    
    /// 검색어가 변경될 때 호출할 메서드
    func updateSearchQuery(_ query: String) {
        // 검색어가 변경되었거나 같은 검색어로 다시 검색할 때 초기화
        if searchQuery != query && query.count >= 2 {
            searchQuery = query
            getChatRoomViewModel.initSearch() // 페이지 번호 초기화
            searchChatData = []
            getChatRoomViewModel.searchChatRoom(target: query)
        }
    }
}
