import SwiftUI

struct FindIDView: View {
    @State private var showingPopUp = false
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()

    var body: some View {
        ScrollView {
            NavigationAvailable {
                VStack {
                    Spacer().frame(height: 147)
                    
                    Image("icon_illust_completion")
                        .frame(width: 68, height: 68)
                        .padding(.horizontal, 126)
                    
                    Spacer().frame(height: 17)
                    
                    Text("휴대폰 번호 정보와\n일치하는 아이디를 가져왔어요")
                        .font(.pretendard(.semibold, size: 16))
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 30)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 280, height: 62)
                            .background(Color("Gray01"))
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .inset(by: 0.5)
                                    .stroke(Color("Gray02"), lineWidth: 1)
                            )
                        
                        Text("2weeksone") // api 연동필요
                            .font(.pretendard(.semibold, size: 18))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer().frame(height: 120)
                    Spacer()
                    
                    bottomButton()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func bottomButton() -> some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: {
                ResetPwView()
            }, label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: .infinity, height: 47)
                        .background(Color("Mint01"))
                        .cornerRadius(4)
                    
                    Text("비밀번호 찾기")
                        .font(.pretendard(.semibold, size: 14))
                        .multilineTextAlignment(.center)
                        .platformTextColor(color: Color("Mint03"))
                }
            })
            
            Button(action: {
                LoginView()
            }, label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: .infinity, height: 47)
                        .background(Color("Mint03"))
                        .cornerRadius(4)
                    
                    Text("확인")
                        .font(.pretendard(.semibold, size: 14))
                        .multilineTextAlignment(.center)
                        .platformTextColor(color: Color("White01"))
                }
            })
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
    
//    private func continueButtonAction() {
//        phoneVerificationViewModel.requestVerifyVerificationCodeAPI {
    ////            checkFormValid()
//            showingPopUp = true
//        }
//    }
    
//    private func checkFormValid() {
//        showingPopUp = true
//    }
}

#Preview {
    FindIDView()
}
