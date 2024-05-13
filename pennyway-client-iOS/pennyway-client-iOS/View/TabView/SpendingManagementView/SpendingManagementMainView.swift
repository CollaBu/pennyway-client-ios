
import SwiftUI

struct SpendingManagementMainView: View {
    var body: some View {
        NavigationAvailable {
            ScrollView {
                VStack {
                    SpendingCheckBoxView()

                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                    ProfileOAuthButtonView()

                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                    ProfileSettingListView(userProfileViewModel: UserProfileViewModel())
                }
                .background(Color("Gray01"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {}, label: {
                            Image("icon_navigation_add")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)

                        Button(action: {}, label: {
                            Image("icon_navigationbar_bell")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)
                    }
                    .offset(x: 10)
                }
            }
        }
    }
}

#Preview {
    SpendingManagementMainView()
}
