
import SwiftUI

struct ProfileMenuBarListView: View {
    var body: some View {
        ScrollView {
            VStack {
                ProfileOAuthButtonView()

                Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                ProfileSettingListView()
            }
            .background(Color("Gray01"))
        }
        .edgesIgnoringSafeArea(.bottom)
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

#Preview {
    ProfileMenuBarListView()
}
