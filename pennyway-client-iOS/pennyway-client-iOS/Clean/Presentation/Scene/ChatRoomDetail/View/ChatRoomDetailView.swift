
import SwiftUI

struct ChatRoomDetailView: View {
    var body: some View {
        NavigationAvailable {
            VStack {
                Image("icon_notifications")
                    .frame(height: 236 * DynamicSizeFactor.factor())
                
                tagSection
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .setTabBarVisibility(isHidden: true)
        }
    }
    
    private var tagSection: some View {
        HStack {
            
        }
    }
}

#Preview {
    ChatRoomDetailView()
}
