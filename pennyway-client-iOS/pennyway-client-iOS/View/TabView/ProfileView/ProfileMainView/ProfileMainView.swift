
import SwiftUI

struct ProfileMainView: View {
    var body: some View {
        NavigationAvailable {
            ScrollView {
                VStack {
                    ProfileUserInfoView()
                    
                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                    
                    ProfileOAuthButtonView()
                    
                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                    
                    ProfileSettingListView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Gray01"))
            .navigationBarTitle("프로필", displayMode: .inline)
        }
    }
}

#Preview {
    ProfileMainView()
}
