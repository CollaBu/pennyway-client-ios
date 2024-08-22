
import SwiftUI

struct ProfileModifyPwView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = UserAccountViewModel()
    @State private var navigateView = false
    @State private var isFormValid = false
    @State private var isPwDeleteButtonVisible: Bool = false
    @Binding var firstNaviLinkActive: Bool
    private let maxLength = 16

    let entryPoint: PasswordChangeTypeNavigation

    var body: some View {
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

                CustomInputView(inputText: $viewModel.password, titleText: "비밀번호", onCommit: {
                    RegistrationManager.shared.oldPassword = viewModel.password

                    validatePwApi()
                    isPwDeleteButtonVisible = false
                }, isSecureText: true, showDeleteButton: true,
                deleteAction: {
                    viewModel.password = ""
                    viewModel.showErrorPassword = false
                    isPwDeleteButtonVisible = false
                })
                .onChange(of: viewModel.password) { newValue in
                    if newValue.count > maxLength {
                        viewModel.password = String(newValue.prefix(maxLength))
                    }
                    isPwDeleteButtonVisible = !newValue.isEmpty
                }

                Spacer().frame(height: 12 * DynamicSizeFactor.factor())

                if viewModel.showErrorPassword {
                    ErrorText(message: "비밀번호가 일치하지 않아요", color: Color("Red03"))
                }

                Spacer()

                CustomBottomButton(action: {
                    if isFormValid {
                        navigateView = true
                        Log.debug("navigateView:\(navigateView)")
                    }
                }, label: "완료", isFormValid: $isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }

            NavigationLink(destination: ResetPwView(firstNaviLinkActive: $firstNaviLinkActive, entryPoint: .modifyPw), isActive: $navigateView) {
                EmptyView()
            }.hidden()
        }
        .onAppear {
            Log.debug("비밀번호 확인 뷰 onappear: \(firstNaviLinkActive)")
        }
        .onDisappear {
            Log.debug("비밀번호 확인 뷰 ondisappear: \(firstNaviLinkActive)")
        }
        .edgesIgnoringSafeArea(.bottom)
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

    func validatePwApi() {
        viewModel.validatePwApi { success in
            if success {
                viewModel.showErrorPassword = false
                isFormValid = true
                Log.debug("비밀번호 검증 완료")
            } else {
                viewModel.showErrorPassword = true
                isFormValid = false
                Log.debug("비밃번호 검증 실패")
            }
        }
    }
}

#Preview {
    ProfileModifyPwView(firstNaviLinkActive: .constant(true), entryPoint: .modifyPw)
}
