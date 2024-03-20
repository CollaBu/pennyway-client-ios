
import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var showingPopUp = false
    
    
    var backButton: some View{
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image("icon_arrow_back")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34, height: 34)
                .padding(5)
                
        })
    }
    
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

                    NumberVerificationView()                 

                    Spacer()
                    
                    Button(action: {
                        showingPopUp = true
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
                
                if showingPopUp {
                    Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                   ErrorCodePopUpView(showingPopUp: $showingPopUp)
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    backButton
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
