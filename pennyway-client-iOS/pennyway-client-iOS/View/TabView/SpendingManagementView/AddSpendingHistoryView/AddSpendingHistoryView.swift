
import SwiftUI
import UIKit

// MARK: - AddSpendingHistoryView

struct AddSpendingHistoryView: View {
    var body: some View {
        VStack {
            ScrollView {
                AddSpendingInputFormView()
            }
            Spacer()

            CustomBottomButton(action: {}, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .background(Color("White01"))
        .navigationBarColor(UIColor(named: "White01"))
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("소비 내역 추가하기", displayMode: .inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        NavigationUtil.popToRootView()
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }
}

#Preview {
    AddSpendingHistoryView()
}
