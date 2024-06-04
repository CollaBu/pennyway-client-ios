
import SwiftUI

struct SpendingDetailSheetView: View {
    @State var navigateToEditView = false
    
    var body: some View {
        ZStack(alignment: .leading) {
//            ScrollView {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 4)
                    .platformTextColor(color: Color("Gray03"))
                    .padding(.top, 12)
                    .padding(.horizontal, 140)
                
                HStack {
                    Text("6월 4일")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                        
                    Spacer()
                        
                    Button(action: {}, label: {
                        Image("icon_expenditure_share")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            
                    })
                    .padding(10)
                        
                    Button(action: {
                        navigateToEditView.toggle()
                    }, label: {
                        Image("icon_navigationbar_write_gray")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            
                    })
                }
                .padding(.top, 32)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                            
                        HStack(alignment: .center, spacing: 10) {
                            Text("최고의 소비")
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Mint03"))
                        }
                        .padding(.horizontal, 10 * DynamicSizeFactor.factor())
                        .padding(.vertical, 4 * DynamicSizeFactor.factor())
                        .background(Color("Ashblue"))
                        .cornerRadius(15)
                            
                        Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                            
                        Text("-0원")
                            .font(.H1BoldFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.vertical, 3 * DynamicSizeFactor.factor()) // line-height 적용하면 지울것
                            
                        Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                            
                        Text("절약했군요! 친구들에게 자랑해 볼까요?")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                    }
                }
            }
            
            NavigationLink(destination: EditSpendingDetailView(), isActive: $navigateToEditView) {
                EmptyView()
            }
        }
        .setTabBarVisibility(isHidden: true)
        .padding(.leading, 20)
        .padding(.trailing, 17)
    }
}

#Preview {
    SpendingDetailSheetView()
}
