import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var confirmPw: String = ""

    @ObservedObject var viewModel: SignUpNavigationViewModel
    
    var body: some View {
        ZStack{
            VStack {
                Spacer().frame(height: 15)
                
                NavigationCountView(selectedText: $viewModel.selectedText)
                    .onAppear {
                        viewModel.selectedText = 2
                    }
                
                Spacer().frame(height: 14)
                
                SignUpFormView()
                
                Spacer()
                
                CustomBottomButton(action: {
                    viewModel.continueButtonTapped()
                }, label: "계속하기", isFormValid: .constant(false))
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                
                NavigationLink(destination: TermsAndConditionsView(viewModel: viewModel), tag: 3, selection: $viewModel.selectedText) {
                    EmptyView()
                }
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
    SignUpView(viewModel: SignUpNavigationViewModel())
}
