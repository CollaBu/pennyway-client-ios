import SwiftUI

struct ResetPwView: View {
    @StateObject var formViewModel = SignUpFormViewModel()
    @State private var navigateView = false

    //    @StateObject var viewModel = SignUpNavigationViewModel()
    
    var body: some View {
        NavigationAvailable {
            VStack {
                ScrollView {
                    HStack(alignment: .top) {
                        Text("새로운 비밀번호를\n설정해주세요")
                            .font(.pretendard(.semibold, size: 24))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 15)
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    Spacer().frame(height: 33)
                    
                    ResetPwFormView(formViewModel: SignUpFormViewModel())
                    
                    Spacer().frame(height: 129)
                    Spacer()
                    
                    VStack {
                        Spacer()
                        CustomBottomButton(action: {
                            if formViewModel.isFormValid {
                                CompleteChangePwView()
                                print(formViewModel.isFormValid)
                                // formViewModel.checkDuplicateUserNameAPI()
                                
                                RegistrationManager.shared.password = formViewModel.password
                                RegistrationManager.shared.performRegistration()
                                
                                navigateView = true
                            } else {}
                            
                        }, label: "변경하기", isFormValid: $formViewModel.isFormValid)
                    }
                    .padding(.bottom, 34)
                    .border(Color.black)
                    
                    NavigationLink(destination: CompleteChangePwView(), isActive: $navigateView) {
                        EmptyView()
                    }.hidden()
                }
                .border(Color.red)
            }
            .frame(maxHeight: .infinity)
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
}

#Preview {
    ResetPwView()
}
