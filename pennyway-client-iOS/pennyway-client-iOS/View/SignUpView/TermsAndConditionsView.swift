import SwiftUI

struct TermsAndConditionsView: View {
    @State private var isSelectedAllBtn: Bool = false
    @State private var isSelectedUseBtn: Bool = false
    @State private var isSelectedInfoBtn: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack{
                Text("이용 약관 동의")
                    .font(.pretendard(.semibold, size: 24))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 20)
            
            Spacer().frame(height: 49)
            
            ScrollView(){
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 28){
                        
                        Button(action: {
                            isSelectedAllBtn.toggle()
                            isSelectedUseBtn.toggle()
                            isSelectedInfoBtn.toggle()
                        }, label: {
                            ZStack(alignment: .leading){
                                Rectangle()
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .platformTextColor(color: isSelectedAllBtn ? Color("Gray05") : Color("Gray02"))
                                    .cornerRadius(4)
                                
                                Image("icon_check") //버튼 눌렀을 때 색 안바뀜
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .platformTextColor(color: isSelectedAllBtn ? Color.white : Color("Gray04"))
                                    .padding(.horizontal,10)
                                Text("모두 동의할게요")
                                    .font(.pretendard(.medium, size: 14))
                                    .platformTextColor(color: isSelectedAllBtn ? Color.white : Color("Gray04"))
                                    .padding(.horizontal,36)
                                
                            }
                        })
                        
                        VStack(alignment: .leading, spacing: 7) {
                            ZStack{
                                HStack{
                                    
                                    Button(action: {
                                        isSelectedUseBtn.toggle()
                                    }, label: {
                                        let selected = isSelectedUseBtn == true ? Image("icon_checkone_on_small") : Image("icon_checkone_off_small")
                                        
                                        selected
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                            .padding(.leading, 4)
                                    })
                                    
                                    
                                    Text("이용약관 (필수)")
                                        .font(.pretendard(.medium, size: 11))
                                        .multilineTextAlignment(.leading)
                                        .platformTextColor(color: Color("Gray04"))
                                }
                            }
                            
                            ZStack() {
                                Rectangle()
                                    .platformTextColor(color: .clear)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .inset(by: 0.5)
                                            .stroke(.gray04.opacity(0.5),lineWidth: 1)
                                    )
                                
                                Text("Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")
                                    .font(.pretendard(.medium, size: 12))
                                    .minimumScaleFactor(0.001)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .platformTextColor(color: Color("Gray04"))
                                    .padding(12)
                            }
                            
                            Spacer().frame(height: 0)
                            
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Button(action: {
                                        isSelectedInfoBtn.toggle()
                                    }, label: {
                                        let selectedInfo = isSelectedInfoBtn == true ? Image("icon_checkone_on_small") : Image("icon_checkone_off_small")
                                        
                                        selectedInfo
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .padding(.leading, 4)
                                    })
                                    Text("개인정보 처리방침 (필수)")
                                        .font(.pretendard(.medium, size: 11))
                                        .multilineTextAlignment(.leading)
                                        .platformTextColor(color: Color("Gray04"))
                                }
                                
                                ZStack{
                                    Rectangle()
                                        .platformTextColor(color: .clear)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(4)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .inset(by: 0.5)
                                                .stroke(.gray04.opacity(0.5),lineWidth: 1)
                                        )
                                    
                                    Text("Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")
                                        .font(.pretendard(.medium, size: 12))
                                        .minimumScaleFactor(0.001)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        .platformTextColor(color: Color("Gray04"))
                                        .padding(12)
                                    
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}




#Preview {
    TermsAndConditionsView()
}
