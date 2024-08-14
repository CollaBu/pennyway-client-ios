import SwiftUI

struct FindIdView: View {
    @State private var goToLoginView = false
    @State private var goToPwView = false
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel
    
    var username = RegistrationManager.shared.username

    var body: some View {
        VStack {
            Spacer().frame(height: 147 * DynamicSizeFactor.factor())
                    
            Image("icon_illust_completion")
                .frame(width: 68 * DynamicSizeFactor.factor(), height: 68 * DynamicSizeFactor.factor())
                .padding(.horizontal, 126)
                    
            Spacer().frame(height: 17 * DynamicSizeFactor.factor())
                    
            Text("휴대폰 번호 정보와\n일치하는 아이디를 가져왔어요")
                .font(.H3SemiboldFont())
                .multilineTextAlignment(.center)
                    
            Spacer().frame(height: 30 * DynamicSizeFactor.factor())
                    
            ZStack {
                Rectangle()
                    .platformTextColor(color: .clear)
                    .frame(width: 280 * DynamicSizeFactor.factor(), height: 62 * DynamicSizeFactor.factor())
                    .background(Color("Gray01"))
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .inset(by: 0.5)
                            .stroke(Color("Gray02"), lineWidth: 1)
                    )                        
                Text("\(username)")
                    .font(.H2SemiboldFont())
                    .multilineTextAlignment(.center)
            }
            Spacer()
                    
            bottomButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .analyzeEvent(AuthCheckEvents.findUsernameView)
    }
    
    private func bottomButton() -> some View {
        HStack(alignment: .center, spacing: 12 * DynamicSizeFactor.factor()) {
            Button(action: {
                goToPwView = true
            }, label: {
                ZStack {
                    Rectangle()
                        .platformTextColor(color: .clear)
                        .frame(width: 134 * DynamicSizeFactor.factor(), height: 47 * DynamicSizeFactor.factor())
                        .background(Color("Mint01"))
                        .cornerRadius(4)
                    
                    Text("비밀번호 찾기")
                        .font(.ButtonH4SemiboldFont())
                        .multilineTextAlignment(.center)
                        .platformTextColor(color: Color("Mint03"))
                    
                    NavigationLink(destination: FindPwView(), isActive: $goToPwView) {
                        EmptyView()
                    }
                    .hidden()
                    .navigationBarBackButtonHidden(true)
                }
            })
            .buttonStyle(BasicButtonStyleUtil())

            Button(action: {
                NavigationUtil.popToRootView()
            }, label: {
                ZStack {
                    Rectangle()
                        .platformTextColor(color: .clear)
                        .frame(width: 134 * DynamicSizeFactor.factor(), height: 47 * DynamicSizeFactor.factor())
                        .background(Color("Mint03"))
                        .cornerRadius(4)
                    
                    Text("확인")
                        .font(.ButtonH4SemiboldFont())
                        .multilineTextAlignment(.center)
                        .platformTextColor(color: Color("White01"))
                }
            })
            .buttonStyle(BasicButtonStyleUtil())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
}

#Preview {
    FindIdView(phoneVerificationViewModel: PhoneVerificationViewModel())
}
