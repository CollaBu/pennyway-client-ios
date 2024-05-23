
import SwiftUI

// MARK: - AddSpendingCategoryView

struct AddSpendingCategoryView: View {
    @State var text = ""

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image("icon_illust_error")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor(), alignment: .leading)

                Image("icon_close_filled_primary")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    .offset(x: 20 * DynamicSizeFactor.factor(), y: 20 * DynamicSizeFactor.factor())
            }

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    if text.isEmpty {
                        Text("카테고리명을 입력하세요")
                            .platformTextColor(color: Color("Gray03"))
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                    }

                    TextField("", text: $text)
                        .padding(.leading, 13 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                }
            }

            Spacer()

            CustomBottomButton(action: {}, label: "추가하기", isFormValid: .constant(false))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .background(Color("White01"))
        .navigationBarColor(UIColor(named: "White01"), title: "")
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
    AddSpendingCategoryView()
}
