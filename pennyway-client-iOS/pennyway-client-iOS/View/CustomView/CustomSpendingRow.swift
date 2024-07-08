
import SwiftUI

struct CustomSpendingRow: View {
    var categoryIcon: String
    var category: String
    var amount: Int
    var memo: String

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                Image(categoryIcon)
                    .resizable()
                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                VStack(alignment: .leading, spacing: 1) {
                    if memo.isEmpty {
                        Text(category)
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: Color("Gray06"))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(category)
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: Color("Gray06"))
                            .multilineTextAlignment(.leading)

                        Text(memo)
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()

                Text("\(amount)원")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray06"))
            }
        }
        .padding(.horizontal, 20)
    }
}
