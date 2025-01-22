
import SwiftUI

struct ChatRoomDetailView: View, ImageLoadable {
    let chatRoom: SearchChatRoomItemModel?
    @State private var isNavigateToSecretRoom = false // 비밀번호 입력방으로 들어가기 위한 변수
    @State private var loadedImage: UIImage? = nil
    @State private var isNavigateToChatRoom = false // 채팅방 내부로 들어가기 위한 변수

    @ObservedObject var viewModelWrapper: ChatViewModelWrapper

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 17 * DynamicSizeFactor.factor())
                
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 236 * DynamicSizeFactor.factor())
                    
                } else {
                    Image("illust_chat_no_BG_picture")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 236 * DynamicSizeFactor.factor())
                }
                
                Spacer().frame(height: 19 * DynamicSizeFactor.factor())
                
                tagSection
                
                Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                
                VStack(alignment: .leading) {
                    if let title = chatRoom?.title {
                        Text("\(title)")
                            .font(.H2SemiboldFont())
                            .platformTextColor(color: Color("Gray07"))
                    }
                    
                    Spacer().frame(height: 7 * DynamicSizeFactor.factor())
                    
                    if let description = chatRoom?.description {
                        Text("\(description)")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomBottomButton(action: {
                    if chatRoom?.isPrivate ?? false {
                        isNavigateToSecretRoom = true
                    } else {
                        if let chatRoomId = chatRoom?.id {
                            Log.debug("[ChatRoomDetailView]: id까지 진입")
                            
                            viewModelWrapper.joinChatRoomViewModel.joinChatRoom(chatRoomId: chatRoomId, password: "") { success in
                                Log.debug("[ChatRoomDetailView]: joinChatRoom까지 진입")
                                
                                if success {
                                    Log.debug("[ChatRoomDetailView]: 채팅방 가입 성공")
                                    isNavigateToChatRoom = true
                                } else {
                                    Log.debug("[ChatRoomDetailView]: 채팅방 가입 실패")
                                }
                            }
                        }
                    }
                }, label: "채팅 참여하기", isFormValid: .constant(true))
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }
            if let chatRoomId = chatRoom?.id {
                if chatRoom?.isPrivate == true {
                    NavigationLink(destination: SecretRoomView(chatRoom: chatRoom ?? nil, chatRoomId: Int64(chatRoomId), viewModelWrapper: viewModelWrapper), isActive: $isNavigateToSecretRoom) {}
                        .hidden()
                } else {
                    NavigationLink(
                        destination: ChatRoomView(chatViewModelWrapper: viewModelWrapper),
                        isActive: $isNavigateToChatRoom
                    ) {}
                        .hidden()
                }
            }
        }
        .navigationBarColor(UIColor(named: "White01"), title: "\(chatRoom?.title ?? "")")
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        .onAppear {
            if let image = chatRoom?.backgroundImageUrl {
                DispatchQueue.main.async {
                    loadImage(from: image) { image in
                        self.loadedImage = image
                    }
                }
            }
        }
    }
    
    private var tagSection: some View {
        HStack(spacing: 9 * DynamicSizeFactor.factor()) {
            if let isPrivate = chatRoom?.isPrivate, isPrivate {
                CustomRoundedBtn(title: "비공개방", fontColor: Color("Mint03"), backgroundColor: Color("Mint01"), style: .large) {}
            }

            if let participantCount = chatRoom?.participantCount {
                CustomRoundedBtn(title: "\(participantCount)명이 대화하고 있어요", fontColor: Color("Yellow02"), backgroundColor: Color("Yellow01"), style: .large) {}
            }
        }
        .padding(.horizontal, 20)
    }
}
