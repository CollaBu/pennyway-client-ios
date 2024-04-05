import SwiftUI

struct TermsAndConditionsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: SignUpNavigationViewModel
    /// @StateObject var termsAndConditionsViewModel = TermsAndConditionsViewModel()
    @State private var isAllAgreed = false

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Spacer().frame(height: 15)
                    
                    NavigationCountView(selectedText: $viewModel.selectedText)
                        .onAppear {
                            viewModel.selectedText = 3
                        }
                    
                    Spacer().frame(height: 14)
                    
                    TermsAndConditionsContentView(isSelectedAllBtn: $isAllAgreed)
                    
                    Spacer()
                }
            }
        }
        VStack {
            CustomBottomButton(action: {
                if isAllAgreed {
                    viewModel.continueButtonTapped()
                }
                // termsAndConditionsViewModel.requestRegistAPI()
            }, label: "계속하기", isFormValid: $isAllAgreed)
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
            
            NavigationLink(destination: WelcomeView(), tag: 4, selection: $viewModel.selectedText) {
                EmptyView()
            }
        }
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
