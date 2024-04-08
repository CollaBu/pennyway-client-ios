import SwiftUI

struct AgreementSectionView: View {
    @Binding var isSelected: Bool
    var title: String
    var contentText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ZStack {
                HStack {
                    Button(action: {
                        isSelected.toggle()
                    }, label: {
                        let selected = isSelected == true ? Image("icon_checkone_on_small") : Image("icon_checkone_off_small")
                        
                        selected
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .padding(.leading, 4)
                    })
                    
                    Text(title)
                        .font(.pretendard(.medium, size: 11))
                        .multilineTextAlignment(.leading)
                        .platformTextColor(color: Color("Gray04"))
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
                            .stroke(.black.opacity(0.5), lineWidth: 1)
                    )
                
                Text(contentText)
                    .font(.pretendard(.medium, size: 12))
                    .minimumScaleFactor(0.001)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .platformTextColor(color: Color("Gray04"))
                    .padding(12)
            }
            
            Spacer().frame(height: 0)
        }
    }
}

#Preview {
    AgreementSectionView(isSelected: .constant(true), title: "", contentText: "")
}
