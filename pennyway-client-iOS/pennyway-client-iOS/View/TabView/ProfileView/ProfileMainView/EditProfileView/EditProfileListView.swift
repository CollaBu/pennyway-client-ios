
import SwiftUI

struct EditProfileListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                CustomRectangleButton(action: {}, label: "아이디 변경")
                
                Spacer().frame(height: 15 * DynamicSizeFactor.factor())
                
                CustomRectangleButton(action: {}, label: "전화번호 변경")
            }
        }
        .setTabBarVisibility(isHidden: true)
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
    }
}

#Preview {
    EditProfileListView()
}