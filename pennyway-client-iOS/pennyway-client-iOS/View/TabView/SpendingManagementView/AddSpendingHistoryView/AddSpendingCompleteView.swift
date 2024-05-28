import SwiftUI

struct AddSpendingCompleteView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    
    var body: some View {
        VStack {
            Image("icon_illust_add history")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160 * DynamicSizeFactor.factor(), height: 160 * DynamicSizeFactor.factor())
                .padding(.top, 65 * DynamicSizeFactor.factor())
            
            Text("소비 내역 추가 완료!")
                .font(.H1SemiboldFont())
            
            Spacer()
           
            VStack(spacing: 16 * DynamicSizeFactor.factor()) {
                HStack {
                    Text("금액")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                    Spacer()
                    Text("\(viewModel.amountSpentText)원")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                }
                HStack {
                    Text("카테고리")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                    
                    Spacer()
                    
                    if let category = viewModel.selectedCategory {
                        HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                            Image(category.0)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                            Text(category.1)
                                .font(.B1MediumFont())
                                .platformTextColor(color: Color("Gray07"))
                        }
                    }
                }
                HStack {
                    Text("날짜")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                    Spacer()
                    Text(Date.getFormattedDate(from: viewModel.selectedDate))
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                }
            }
            .padding(.horizontal, 20)
           
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
            
            CustomBottomButton(action: {
                NavigationUtil.popToRootView()
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddSpendingCompleteView(viewModel: AddSpendingHistoryViewModel())
}
