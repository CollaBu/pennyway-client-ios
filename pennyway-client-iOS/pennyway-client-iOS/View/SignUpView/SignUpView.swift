
import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    
    var backButton: some View{
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image("icon_arrow_back")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        })
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 14) {
                Spacer().frame(height: 0)
                HStack(spacing: 8){
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        Text("1")
                            .padding(6)
                            .background(Color("Gray06"))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .font(.system(size: 12, weight: .medium))
                        Text("2")
                            .padding(6)
                            .background(Color("Gray03"))
                            .foregroundColor(Color("Gray04"))
                            .clipShape(Circle())
                            .font(.system(size: 12, weight: .medium))
                        Text("3")
                            .padding(6)
                            .background(Color("Gray03"))
                            .foregroundColor(Color("Gray04"))
                            .clipShape(Circle())
                            .font(.system(size: 12, weight: .medium))
                    }
                    Spacer()
                }.padding(.horizontal, 20)
                    .frame(height: 20)
                
                NumberVerificationView(phoneNumber: $phoneNumber, verificationCode: $verificationCode)
                
                Spacer()
  
                
                Button(action: {
                    
                }) {
                    Text("계속하기")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Gray04"))
                }
                .frame(height: 47)
                .frame(maxWidth: .infinity)
                .background(Color("Gray02"))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.horizontal, 20)
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}


#Preview {
    SignUpView()
}
