import SwiftUI

struct AddSpendingCompleteView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @Binding var clickDate: Date?
    @Binding var isPresented: Bool
    @Binding var isAddSpendingData: Bool
    var entryPoint: EntryPoint
    
    var body: some View {
        VStack {
            Image("icon_illust_add_history")
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
                            Image(category.icon.rawValue)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                            Text(category.name)
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
                        
                    Text(Date.getFormattedDate(from: clickDate ?? viewModel.selectedDate))
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                }
            }
            .padding(.horizontal, 20)
                
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                
            CustomBottomButton(action: {
                Log.debug("버튼 누름")
                if entryPoint == .main {
                    isAddSpendingData = true
                    NavigationUtil.popToRootView()
                    
                    Log.debug("루트뷰로이동")
                } else {
                    if entryPoint == .NoSpendingHistoryView {
                        NavigationUtil.popToView(at: 1)
                    } else {
                        isPresented = false
                        Log.debug("isPresented: \(isPresented)")
                        Log.debug("entryPoint: \(entryPoint)")
                    }
                }
                
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .analyzeEvent(SpendingEvents.spendingAddCompleteView)
    }
}

#Preview {
    AddSpendingCompleteView(viewModel: AddSpendingHistoryViewModel(), clickDate: .constant(Date()), isPresented: .constant(true), isAddSpendingData: .constant(true), entryPoint: .main)
}
