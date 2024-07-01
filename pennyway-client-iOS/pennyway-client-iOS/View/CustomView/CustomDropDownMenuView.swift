
import SwiftUI

struct CustomDropdownMenuView: View {
    @Binding var isClickMenu: Bool
    @Binding var selectedMenu: String?
    let listArray: [String]
    let onItemSelected: (String) -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 118 * DynamicSizeFactor.factor(), height: 66 * DynamicSizeFactor.factor())
                .cornerRadius(4)
                .platformTextColor(color: Color("White01"))
                .shadow(color: .black.opacity(0.06), radius: 7, x: 0, y: 0)
                .padding(4)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(listArray, id: \.self) { item in
                    Button(action: {
                        selectedMenu = item
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isClickMenu = false
                        }
                        onItemSelected(item)
                    }, label: {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: 110 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                                .cornerRadius(3)
                                .platformTextColor(color: selectedMenu == item ? Color("Gray02") : Color("White01"))
                            Text(item)
                                .font(.B2MediumFont())
                                .platformTextColor(color: selectedMenu == item ? Color("Gray05") : Color("Gray04"))
                                .padding(.horizontal, 7)
                        }
                        .padding(.vertical, 2)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .cornerRadius(3)
            }
        }
    }
}
