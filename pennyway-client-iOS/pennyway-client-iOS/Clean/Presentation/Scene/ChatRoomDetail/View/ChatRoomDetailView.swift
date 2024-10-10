
import SwiftUI

struct ChatRoomDetailView: View {
    @State private var isNavigate = false

    var body: some View {
        NavigationAvailable {
            VStack(alignment: .leading) {
                Spacer().frame(height: 17 * DynamicSizeFactor.factor())

                Image("icon_close")
                    .frame(maxWidth: .infinity, maxHeight: 236 * DynamicSizeFactor.factor())
                    .border(Color.black)

                Spacer().frame(height: 19 * DynamicSizeFactor.factor())

                tagSection

                Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                VStack(alignment: .leading) {
                    Text("배달음식 그만 먹는 방")
                        .font(.H2SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer().frame(height: 7 * DynamicSizeFactor.factor())

                    Text("배달음식 NO 집밥 YES")
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
    }

    private var tagSection: some View {
        HStack(spacing: 9 * DynamicSizeFactor.factor()) {
            CustomRoundedBtn(title: "비공개방", fontColor: Color("Mint03"), backgroundColor: Color("Mint01")) {}

            CustomRoundedBtn(title: "127명이 대화하고 있어요", fontColor: Color("Yellow02"), backgroundColor: Color("Yellow01")) {}
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ChatRoomDetailView()
}
