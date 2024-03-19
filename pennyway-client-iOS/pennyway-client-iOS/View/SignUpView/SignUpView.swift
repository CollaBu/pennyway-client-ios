
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

        NavigationAvailable{
            VStack(spacing: 14) {
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

                NumberVerificationView(phoneNumber: $phoneNumber, verificationCode: $verificationCode)

                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("계속하기")
                        .font(.pretendard(.semibold, size: 14))
                        .platformTextColor(color: Color("Gray04"))
                })
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
