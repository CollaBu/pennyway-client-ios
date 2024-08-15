
import SwiftUI

struct NoSpendingHistoryView: View {
    @State var navigateToAddSpendingHistory = false
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

    @Binding var clickDate: Date?

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 50 * DynamicSizeFactor.factor())
            Image("icon_illust_nohistory")
                .frame(width: 32 * DynamicSizeFactor.factor(), height: 42 * DynamicSizeFactor.factor())
                .padding()

            Spacer().frame(height: 11 * DynamicSizeFactor.factor())

            Text("소비 내역이 없어요")
                .platformTextColor(color: Color("Gray04"))
                .font(.H4MediumFont())

            Spacer().frame(height: 20 * DynamicSizeFactor.factor())

            Button(action: {
                self.navigateToAddSpendingHistory = true
            }, label: {
                ZStack {
                    HStack(alignment: .center, spacing: 10) {
                        Text("추가하기")
                            .platformTextColor(color: Color("White01"))
                            .font(.B2MediumFont())
                    }
                    .padding(.horizontal, 10 * DynamicSizeFactor.factor())
                    .padding(.vertical, 5 * DynamicSizeFactor.factor())
                    .background(Color("Mint03"))
                    .cornerRadius(30)

                    NavigationLink(destination: AddSpendingHistoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), spendingHistoryViewModel: spendingHistoryViewModel, spendingId: .constant(0), clickDate: $clickDate, isPresented: $navigateToAddSpendingHistory, isEditSuccess: .constant(false), entryPoint: .detailSheet), isActive: $navigateToAddSpendingHistory) {
                        EmptyView()
                    }.hidden()
                }
            })
            .buttonStyle(BasicButtonStyleUtil())
        }
    }
}

#Preview {
    NoSpendingHistoryView(spendingHistoryViewModel: SpendingHistoryViewModel(), clickDate: .constant(Date()))
}
