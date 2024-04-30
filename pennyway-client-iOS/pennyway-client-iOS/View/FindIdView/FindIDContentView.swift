

import SwiftUI

struct FindIDContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel
    
    var body: some View {
        VStack {
            Spacer().frame(height: 36)
            
            FindIDPhoneVerificationView(viewModel: phoneVerificationViewModel)
            
            Spacer().frame(height: 21)
            
            NumberInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    FindIDContentView(phoneVerificationViewModel: PhoneVerificationViewModel())
}
