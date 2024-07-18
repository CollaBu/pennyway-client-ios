
import SwiftUI

struct ProfileModifyPwView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var formViewModel = SignUpFormViewModel()
    @State private var navigateView = false

    var body: some View {
        NavigationAvailable {
            ZStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        Text("현재 비밀번호를\n입력해주세요")
                            .font(.H1SemiboldFont())
                            .multilineTextAlignment(.leading)
                            .padding(.top, 15 * DynamicSizeFactor.factor())
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    Spacer().frame(height: 33 * DynamicSizeFactor.factor())
                    
                    CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                        formViewModel.validatePassword()
                    }, isSecureText: true)
                    
                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    
                    if formViewModel.showErrorPassword {
                        errorMessage("비밀번호가 일치하지 않아요")
                    }
                    
                    Spacer()
                    
                    CustomBottomButton(action: {
                        navigateView = true
                        
                    }, label: "완료", isFormValid: .constant(true))
                        .padding(.bottom, 34 * DynamicSizeFactor.factor())
                    
                    NavigationLink(destination: ResetPwView(), isActive: $navigateView) {
                        EmptyView()
                    }.hidden()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }

    private func errorMessage(_ message: String) -> some View {
        Text(message)
            .padding(.leading, 20 * DynamicSizeFactor.factor())
            .font(.B1MediumFont())
            .platformTextColor(color: Color("Red03"))
    }
}

#Preview {
    ProfileModifyPwView()
}
