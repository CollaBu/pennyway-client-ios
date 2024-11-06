
import SwiftUI

struct ChatRoomDetailView: View {
    let chatRoom: SearchChatRoomItemModel
    @State private var isNavigate = false

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 17 * DynamicSizeFactor.factor())

            Image("icon_close")
                .frame(maxWidth: .infinity, maxHeight: 236 * DynamicSizeFactor.factor())
                .border(Color.black)

            Spacer().frame(height: 19 * DynamicSizeFactor.factor())

            tagSection

            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            VStack(alignment: .leading) {
                Text("\(chatRoom.title)")
                    .font(.H2SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 7 * DynamicSizeFactor.factor())

                Text("\(chatRoom.description)")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray04"))
            }
            .padding(.horizontal, 20)

            Spacer()

            CustomBottomButton(action: {
                isNavigate = true
            }, label: "채팅 참여하기", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())

            NavigationLink(destination: SecretRoomView(), isActive: $isNavigate) {}
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
    }

    private var tagSection: some View {
        HStack(spacing: 9 * DynamicSizeFactor.factor()) {
            CustomRoundedBtn(title: chatRoom.isPrivate ? "비공개방" : "", fontColor: Color("Mint03"), backgroundColor: Color("Mint01"), style: .large) {}

            CustomRoundedBtn(title: "\(chatRoom.participantCount)명이 대화하고 있어요", fontColor: Color("Yellow02"), backgroundColor: Color("Yellow01"), style: .large) {}
        }
        .padding(.horizontal, 20)
    }
}

//
// #Preview {
//    ChatRoomDetailView(chatRoom: )
// }
