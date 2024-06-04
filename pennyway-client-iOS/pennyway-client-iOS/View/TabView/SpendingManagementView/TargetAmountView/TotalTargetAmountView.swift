import SwiftUI

struct TotalTargetAmountView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TotalTargetAmountHeaderView()

                TotalTargetAmountContentView()

                Spacer().frame(height: 29 * DynamicSizeFactor.factor())
            }
        }
        .background(Color("Gray01"))
    }
}

#Preview {
    TotalTargetAmountView()
}
