
import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var confirmPw: String = ""
    
    @State private var selectedText: Int? = 2
    
    var body: some View {
        ZStack{
            VStack(spacing: 14) {
                Spacer().frame(height: 10)
                
                NavigationCountView(selectedText: $selectedText)
                    .onAppear {
                        selectedText = 2
                    }
                
                SignUpFormView(name: $name, id: $id, password: $password, confirmPw: $confirmPw)
                
                Spacer()
                
                CustomBottomButton(action: {
                    selectedText = 3
                }, label: "계속하기")
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                
                NavigationLink(destination: TermsAndConditionsView(), tag: 3, selection: $selectedText) {
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
    SignUpView()
}
