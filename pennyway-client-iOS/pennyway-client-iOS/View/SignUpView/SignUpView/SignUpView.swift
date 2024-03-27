import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var confirmPw: String = ""
    @State private var isActiveButton: Bool = true
    
    @StateObject var formViewModel = SignUpFormViewModel()
    @StateObject var viewModel = SignUpNavigationViewModel()
    //@ObservedObject var viewModel: SignUpNavigationViewModel
    //@ObservedObject var formViewModel: SignUpFormViewModel
    
    var body: some View {
        
        ScrollView() {
            VStack(spacing: 47){
                VStack {
                    Spacer().frame(height: 15)
                    
                    NavigationCountView(selectedText: $viewModel.selectedText)
                        .onAppear {
                            viewModel.selectedText = 2
                        }
                    
                    Spacer().frame(height: 14)
                    
                    //                    SignUpFormView()
                    SignUpFormView(formViewModel: formViewModel)
                    
                }
            }
            
            Spacer().frame(height: 47)
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
        
        VStack {
            CustomBottomButton(action: {
                if formViewModel.isFormValid {
                    viewModel.continueButtonTapped()
                    print(formViewModel.isFormValid)
                } else {
                    
                }
                    
            }, label: "계속하기", isFormValid: $formViewModel.isFormValid)
                    .padding(.bottom, 20)
                
                
            NavigationLink(destination: TermsAndConditionsView(viewModel: viewModel), tag: 3, selection: $viewModel.selectedText) {
                EmptyView()
            }
        }
    }
}
#Preview {
    SignUpView(viewModel: SignUpNavigationViewModel())
}
