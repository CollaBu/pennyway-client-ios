
import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var confirmPw: String = ""
    
    @State var showErrorVerificationCode = false
   
    var body: some View {
        
        NavigationAvailable{
            ZStack{
                VStack(spacing: 14) {
                    Spacer().frame(height: 10)
                    
                    HStack(spacing: 8){
                        LazyHGrid(rows: [GridItem(.flexible())]) {
                            Text("1")
                                .padding(6)
                                .background(Color("Gray06"))
                                .platformTextColor(color: Color("White"))
                                .clipShape(Circle())
                                .font(.pretendard(.medium, size: 12))
                            Text("2")
                                .padding(6)
                                .background(Color("Gray03"))
                                .platformTextColor(color: Color("Gray04"))
                                .clipShape(Circle())
                                .font(.pretendard(.medium, size: 12))
                            Text("3")
                                .padding(6)
                                .background(Color("Gray03"))
                                .platformTextColor(color: Color("Gray04"))
                                .clipShape(Circle())
                                .font(.pretendard(.medium, size: 12))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 20)
                    
                    SignUpFormView(name: $name, id: $id, password: $password, confirmPw: $confirmPw)
                    
                    Spacer()
                    
                    Button(action: {
                        
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

#Preview {
    SignUpView()
}
