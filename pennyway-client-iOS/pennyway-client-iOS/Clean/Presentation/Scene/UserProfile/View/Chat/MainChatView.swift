
import SwiftUI

// MARK: - MainChatView

struct MainChatView: View {
    @State private var selectedTab: Int = 0
    @State private var chatRoomName: String = "" // 수정 예정

    var body: some View {
        NavigationAvailable {
            VStack {
                Spacer().frame(height: 38 * DynamicSizeFactor.factor())

                HStack(spacing: 30) {
                    Button(action: {
                        selectedTab = 1
                    }, label: {
                        MyChatContainer
//                        VStack {
//                            if selectedTab == 1 {
//                                ZStack {
//                                    Circle()
//                                        .platformTextColor(color: Color("Mint03"))
//                                        .frame(width: 7 * DynamicSizeFactor.factor(), height: 7 * DynamicSizeFactor.factor())
//                                        .offset(x: 32 * DynamicSizeFactor.factor(), y: -16 * DynamicSizeFactor.factor())
//
//                                    VStack {
//                                        Text("내 채팅")
//                                            .font(.ButtonH4SemiboldFont())
//                                            .platformTextColor(color: Color("Mint03"))
//
//                                        Capsule()
//                                            .platformTextColor(color: Color("Mint03"))
//                                            .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
//                                            .padding(.top, 4)
//                                    }
//                                }
//                            } else {
//                                Text("내 채팅")
//                                    .font(.ButtonH4SemiboldFont())
//                                    .platformTextColor(color: Color("Gray07"))
//
//                                Capsule()
//                                    .fill(Color.clear)
//                                    .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
//                                    .padding(.top, 4)
//                            }
//                        }
                    })

                    Button(action: {
                        selectedTab = 2
                    }, label: {
                        RecommendChatContainer
//                        VStack {
//                            if selectedTab == 2 {
//                                ZStack {
//                                    Circle()
//                                        .platformTextColor(color: Color("Mint03"))
//                                        .frame(width: 7 * DynamicSizeFactor.factor(), height: 7 * DynamicSizeFactor.factor())
//                                        .offset(x: 37 * DynamicSizeFactor.factor(), y: -16 * DynamicSizeFactor.factor())
//
//                                    VStack {
//                                        Text("추천 채팅")
//                                            .font(.ButtonH4SemiboldFont())
//                                            .platformTextColor(color: Color("Mint03"))
//
//                                        Capsule()
//                                            .platformTextColor(color: Color("Mint03"))
//                                            .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
//                                            .padding(.top, 4)
//                                    }
//                                }
//
//                            } else {
//                                Text("추천 채팅")
//                                    .font(.ButtonH4SemiboldFont())
//                                    .platformTextColor(color: Color("Gray07"))
//
//                                Capsule()
//                                    .fill(Color.clear)
//                                    .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
//                                    .padding(.top, 4)
//                            }
//                        }
                    })
                }

                Spacer().frame(height: 28 * DynamicSizeFactor.factor())

                CustomInputView(inputText: $chatRoomName, placeholder: "원하는 주제를 찾아보세요", isSecureText: false, showSearchBtn: true)

                Spacer().frame(height: 23 * DynamicSizeFactor.factor())

                if selectedTab == 0 {
                    Spacer()
                } else if selectedTab == 1 {
                    ChatRoomContent(isMyChat: true)
                } else if selectedTab == 2 {
                    ChatRoomContent(isMyChat: false)
                }
            }
            .navigationBarColor(UIColor(named: "White01"), title: "채팅방")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {}, label: {
                            Image("icon_navigationbar_mint")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        })
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                }
            }
        }
    }

    private var MyChatContainer: some View {
        VStack {
            if selectedTab == 1 {
                ZStack {
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
    }

    private var RecommendChatContainer: some View {
        VStack {
            if selectedTab == 2 {
                ZStack {
                    Circle()
                        .platformTextColor(color: Color("Mint03"))
                        .frame(width: 7 * DynamicSizeFactor.factor(), height: 7 * DynamicSizeFactor.factor())
                        .offset(x: 37 * DynamicSizeFactor.factor(), y: -16 * DynamicSizeFactor.factor())

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
    }
}

// MARK: - MainChatViewModelWrapper

final class MainChatViewModelWrapper: ObservableObject {
    @Published var chatData: ChatItemViewModel

    init(chatData: ChatItemViewModel) {
        self.chatData = chatData
    }
}

#Preview {
    MainChatView()
}
