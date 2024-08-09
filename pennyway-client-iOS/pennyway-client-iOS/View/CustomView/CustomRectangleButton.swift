
import SwiftUI

struct CustomRectangleButton: View {
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .frame(height: 50 * DynamicSizeFactor.factor())
                    .cornerRadius(8)
                    .platformTextColor(color: Color("White01"))

                HStack {
                    Text("\(label)")
                        .font(.ButtonH4SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.leading, 18)

                    Spacer()

                    Image("icon_arrow_front_small")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        .padding(.trailing, 13)
                }
            }
        }
        .padding(.horizontal, 20)
        .buttonStyle(PlainButtonStyle())
        .buttonStyle(BasicButtonStyleUtil())
    }
}
