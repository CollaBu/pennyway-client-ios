import SwiftUI

struct InquiryListView: View {
    @State private var isSelectedCategory: Bool = false
    @State var show = true
    @State var name = "Item1"
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 159 * DynamicSizeFactor.factor(), height: 46 * DynamicSizeFactor.factor())
                    .background(Color("Gray01"))
                    .cornerRadius(3)
                
                Text("카테고리 선택")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray03"))
                    .padding(.leading, 13 * DynamicSizeFactor.factor())
                
                Spacer()
                
                Button(action: {
                    isSelectedCategory.toggle()
                }, label: {
                    let selected = isSelectedCategory == true ? Image("icon_arrow_up") : Image("icon_arrow_down")
                    
                    selected
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    
                })
                .offset(x: 124 * DynamicSizeFactor.factor())
            }
            .padding(.leading, 20)
            
            if isSelectedCategory {
                VStack(alignment: .center) {
//                    Spacer().frame(height: 6)
                    InquiryListContentView()
                }
            }
        }
    }
}

#Preview {
    InquiryListView()
}
