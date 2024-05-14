import SwiftUI

struct AgreementSectionView: View {
    @Binding var isSelected: Bool
    var title: String
    var contentText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 7 * DynamicSizeFactor.factor()) {
            ZStack {
                HStack(spacing: 3) {
                    Button(action: {
                        isSelected.toggle()
                    }, label: {
                        let selected = isSelected == true ? Image("icon_checkone_on_small") : Image("icon_checkone_off_small")

                        selected
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)

                    })
                    .padding(.leading, 8 * DynamicSizeFactor.factor())

                    Text(title)
                        .font(.B2MediumFont())
                        .multilineTextAlignment(.leading)
                        .platformTextColor(color: isSelected ? .black : Color("Gray05"))
                }
            }

            ZStack {
                Rectangle()
                    .platformTextColor(color: .clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .inset(by: 0.5)
                            .stroke(Color("Gray01"), lineWidth: 1)
                    )

                Text(contentText)
                    .font(.B1RegularFont())
                    .minimumScaleFactor(0.001)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .platformTextColor(color: Color("Gray04"))
                    .padding(12 * DynamicSizeFactor.factor())
            }
        }
    }
}

#Preview {
    AgreementSectionView(isSelected: .constant(true), title: "", contentText: "")
}
