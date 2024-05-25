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
                    
                    if let categoryIcon = viewModel.selectedCategoryIcon {
                        HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                            Image(categoryIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32 * DynamicSizeFactor.factor(), height: 32 * DynamicSizeFactor.factor())
                            Text(viewModel.categoryName)
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
