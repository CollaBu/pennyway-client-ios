
import SwiftUI

struct ProfileMainView: View {
    var body: some View {
        NavigationAvailable {
            VStack {
                Text("Profile Main View")

                ProfileUserInfoView()
                ProfileOAuthButtonView()
                ProfileSettingListView()
            }
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
}

#Preview {
    ProfileMainView()
}
