
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
                
                Button(action: {
                    selectedText = 3
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
