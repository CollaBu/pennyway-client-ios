import SwiftUI

struct TermsAndConditionsView: View {
    @StateObject var signUpViewModel = SignUpViewModel()
    @State private var isAllAgreed = false
    @ObservedObject var viewModel: SignUpNavigationViewModel

    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    VStack {
                        Spacer().frame(height: 15 * DynamicSizeFactor.factor())

                        NavigationCountView(selectedText: $viewModel.selectedText)
                            .onAppear {
                                viewModel.selectedText = 3
                            }

                        Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                        TermsAndConditionsContentView(isSelectedAllBtn: $isAllAgreed)

                        Spacer()
                    }
                }
            }
            Spacer()

            CustomBottomButton(action: {
                if isAllAgreed {
                    if isOAuthRegistration {
                        signUpViewModel.oauthSignUp { success, userId in
                            if success, let userId = userId {
                                AnalyticsManager.shared.setUser("userId = \(userId.id)")
                                AnalyticsManager.shared.trackEvent(AuthEvents.signUp, additionalParams: [
                                    AnalyticsConstants.Parameter.oauthType: OAuthRegistrationManager.shared.provider,
                                ])
                                viewModel.continueButtonTapped()
                            }
                        }
                    } else {
                        signUpViewModel.signUp { success, userId in
                            if success, let userId = userId {
                                AnalyticsManager.shared.setUser("userId = \(userId.id)")
                                AnalyticsManager.shared.trackEvent(AuthEvents.signUp, additionalParams: [
                                    AnalyticsConstants.Parameter.oauthType: "none",
                                ])
                                viewModel.continueButtonTapped()
                            }
                        }
                    }
                }
            }, label: "계속하기", isFormValid: $isAllAgreed)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())

            NavigationLink(destination: WelcomeView(), tag: 4, selection: $viewModel.selectedText) {
                EmptyView()
            }.hidden()
        }
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .edgesIgnoringSafeArea(.bottom)
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

#Preview {
    TermsAndConditionsView(viewModel: SignUpNavigationViewModel())
}
