
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
                .background(Color("Gray01"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("프로필", displayMode: .inline)
        }
    }
}

#Preview {
    ProfileMainView()
}
