import SwiftUI

struct NumberVerificationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var showingPopUp = false
    @State var showErrorVerificationCode = true
    @State private var selectedText: Int? = 1
    
    var body: some View {
        NavigationAvailable {
            ZStack{
                VStack(spacing: 14) {
                    Spacer().frame(height: 10)
                    
                    NavigationCountView(selectedText: $selectedText) 
                        .onAppear {
                            selectedText = 1
                        }
                    
                    NumberVerificationContentView(showErrorVerificationCode: $showErrorVerificationCode)
                    
                    Spacer()
                    
                    CustomBottomButton(action: {
                        if !showErrorVerificationCode {
                            showingPopUp = false
                            selectedText = 2
                        } else {
                            showingPopUp = true
                        }
                    }, label: "계속하기")
                    .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                    .border(Color.black)
                    
                    
                    NavigationLink(destination: SignUpView(), tag: 2, selection: $selectedText) {
                        EmptyView()
                    }
                }
               
                
                if showingPopUp {
                    Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                    ErrorCodePopUpView(showingPopUp: $showingPopUp)
                }
                    
            }
            .border(.red)
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
    NumberVerificationView()
}
