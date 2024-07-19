
import SwiftUI

struct EditProfileListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var isNavigateToEditIdView = false
    @State var isNavigateToEditPhoneView = false
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())
                
                CustomRectangleButton(action: {
                    isNavigateToEditIdView = true
                }, label: "아이디 변경")
                
                Spacer().frame(height: 15 * DynamicSizeFactor.factor())
                
                CustomRectangleButton(action: {
                    isNavigateToEditPhoneView = true
                }, label: "전화번호 변경")
            }
        }
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "Gray01"), title: "내 정보 수정")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Gray01"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                }.offset(x: -10)
            }
        }
        
        NavigationLink(destination: EditIdView(), isActive: $isNavigateToEditIdView) {}
        NavigationLink(destination: EditPhoneNumberView(), isActive: $isNavigateToEditPhoneView) {}
    }
}

#Preview {
    EditProfileListView()
}