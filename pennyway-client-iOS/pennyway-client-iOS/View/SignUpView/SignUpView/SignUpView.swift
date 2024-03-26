import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var confirmPw: String = ""
    
    @ObservedObject var viewModel: SignUpNavigationViewModel
    
    var body: some View {
<<<<<<< HEAD
        ScrollView() {
            VStack(spacing: 47){
                VStack {
                    Spacer().frame(height: 15)
                    
                    NavigationCountView(selectedText: $viewModel.selectedText)
                        .onAppear {
                            viewModel.selectedText = 2
                        }
                    
                    Spacer().frame(height: 14)
                    
                    SignUpFormView()
                    
                    
=======
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
                }, label: "계속하기")
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                
                NavigationLink(destination: TermsAndConditionsView(viewModel: viewModel), tag: 3, selection: $viewModel.selectedText) {
                    EmptyView()
>>>>>>> 7508c42c783da61113f2cb8320cd89aad05ce5a6
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
        }
        
        VStack {
            CustomBottomButton(action: {
                viewModel.continueButtonTapped()
            }, label: "계속하기")
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
