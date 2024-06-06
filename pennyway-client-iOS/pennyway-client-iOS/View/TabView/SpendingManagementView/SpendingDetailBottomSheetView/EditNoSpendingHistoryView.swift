
import SwiftUI

struct EditNoSpendingHistoryView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 100 * DynamicSizeFactor.factor())

            Text("소비 내역이 없어요")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))

            Spacer().frame(height: 8 * DynamicSizeFactor.factor())

            Text("붕어빵님의 소비를 기록해 보세요")
                .font(.B2MediumFont())
                .platformTextColor(color: Color("Gray04"))
        }
    }
}

#Preview {
    EditNoSpendingHistoryView()
}
