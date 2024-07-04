
import SwiftUI

// MARK: - CategorySpendingListView

struct CategorySpendingListView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @Environment(\.presentationMode) var presentationMode
    var category: SpendingCategoryData

    var body: some View {
        VStack {
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())

            Image("\(category.icon.rawValue)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor())

            Spacer().frame(height: 12 * DynamicSizeFactor.factor())

            Text(category.name)
                .font(.H3SemiboldFont())
                .platformTextColor(color: Color("Gray07"))

            Spacer().frame(height: 4 * DynamicSizeFactor.factor())

            Text("몇개의 소비 내역")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))

            Spacer()
        }
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
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
            ToolbarItem(placement: .topBarTrailing) {
                if category.isCustom {
                    HStack {
                        Button(action: {}, label: {
                            Image("icon_navigationbar_kebabmenu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)
                    }.offset(x: 10)
                }
            }
        }
    }
}
