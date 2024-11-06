
import SwiftUI

struct ChatRoomDetailView: View, ImageLoadable {
    let chatRoom: SearchChatRoomItemModel?
    @State private var isNavigate = false
    @State private var loadedImage: UIImage? = nil

    @ObservedObject var viewModelWrapper: ChatViewModelWrapper

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 17 * DynamicSizeFactor.factor())

            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 236 * DynamicSizeFactor.factor())

            } else {
                Image("icon_notifications") // 임시 아이콘
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
                isNavigate = true
            }, label: "채팅 참여하기", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())

            NavigationLink(destination: navigationDestination, isActive: $isNavigate) {}
                .hidden()
        }
        .navigationBarColor(UIColor(named: "White01"), title: "채팅방")
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

    @ViewBuilder
    private var navigationDestination: some View {
        if chatRoom?.isPrivate == true {
            SecretRoomView(viewModelWrapper: viewModelWrapper)
        } else {
            MakeUsernameView(viewModelWrapper: viewModelWrapper)
        }
    }
}
