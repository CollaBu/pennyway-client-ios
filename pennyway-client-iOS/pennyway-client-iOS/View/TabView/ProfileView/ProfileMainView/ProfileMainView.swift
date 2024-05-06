
import SwiftUI

struct ProfileMainView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationAvailable {
            ScrollView {
                VStack {
                    ProfileUserInfoView()
                    
                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                    
                    ProfileOAuthButtonView()
                    
                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                    
                    ProfileSettingListView(viewModel: UserProfileViewModel(appViewModel: appViewModel))
                }
                .background(Color("Gray01"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("프로필", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {}, label: {
                            Image("icon_navigationbar_bell_dot")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 34)
                                .padding(5)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileMainView(appViewModel: AppViewModel())
}
