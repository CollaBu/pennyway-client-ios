
import SwiftUI

struct EditProfileListView: View {
    @State var isNavigateToEditIdView = false
    @State var isNavigateToEditPhoneView = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Spacer().frame(height: 35 * DynamicSizeFactor.factor())
                    
                    CustomRectangleButton(action: {
                        isNavigateToEditIdView = true
                    }, label: "아이디 변경")
                    
                    Spacer().frame(height: 15 * DynamicSizeFactor.factor())
                    
                    CustomRectangleButton(action: {
                        isNavigateToEditPhoneView = true
                    }, label: "휴대폰 번호 변경")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Gray01"))
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "Gray01"), title: "내 정보 수정")
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        
        NavigationLink(destination: EditIdView(), isActive: $isNavigateToEditIdView) {}
            .hidden()
        NavigationLink(destination: EditPhoneNumberView(), isActive: $isNavigateToEditPhoneView) {}
            .hidden()
    }
}

#Preview {
    EditProfileListView()
}
