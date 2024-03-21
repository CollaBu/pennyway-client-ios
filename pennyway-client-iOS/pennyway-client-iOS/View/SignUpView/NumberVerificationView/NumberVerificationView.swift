import SwiftUI

struct NumberVerificationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var showingPopUp = false
    @State var showErrorVerificationCode = false
    @State private var selectedText: Int? = 1
    
    var body: some View {
        NavigationAvailable {
            ZStack{
                VStack(spacing: 14) {
                    Spacer().frame(height: 10)
                    
                    NavigationCountView(selectedText: $selectedText) 
                    
                    NumberVerificationContentView(showErrorVerificationCode: $showErrorVerificationCode)
                    
                    Spacer()
                    
                    Button(action: {
                        if !showErrorVerificationCode {
                            showingPopUp = false
                            selectedText = 2
                        } else {
                            showingPopUp = true
                        }
                    }, label: {
                        Text("계속하기")
                            .font(.pretendard(.semibold, size: 14))
                            .platformTextColor(color: Color("Gray04"))
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 17)
                    })
                    .frame(maxWidth: .infinity)
                    .background(Color("Gray02"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(.horizontal, 20)
                    .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                    
                    NavigationLink(destination: SignUpView(), tag: 2, selection: $selectedText) {
                        EmptyView()
                    }
                }
                
                if showingPopUp {
                    Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                    ErrorCodePopUpView(showingPopUp: $showingPopUp)
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
}
