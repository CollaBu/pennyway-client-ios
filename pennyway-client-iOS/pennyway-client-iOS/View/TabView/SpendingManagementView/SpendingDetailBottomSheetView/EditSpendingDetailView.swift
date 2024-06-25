import SwiftUI

// MARK: - EditSpendingDetailView

struct EditSpendingDetailView: View {
    @State var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode

//    @Binding var showEditSpendingDetailView: Bool

    @State var spendingDetails: [SpendingDetail] = [
        SpendingDetail(category: "편의점/마트", description: "", amount: "1,000원", icon: "icon_category_market_on"),
        SpendingDetail(category: "교육", description: "스터디용 메모장", amount: "6,000원", icon: "icon_category_education_on"),
        SpendingDetail(category: "교통", description: "", amount: "3,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "편의점/마트", description: "", amount: "1,000원", icon: "icon_category_market_on"),
        SpendingDetail(category: "교육", description: "스터디용 메모장", amount: "6,000원", icon: "icon_category_education_on"),
        SpendingDetail(category: "교통", description: "", amount: "3,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "교통", description: "", amount: "1,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "교통", description: "", amount: "10,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "교통", description: "", amount: "3,000원", icon: "icon_category_traffic_on")
    ]

    var body: some View {
        // ZStack(alignment: .leading) {
        VStack {
            ScrollView {
                Spacer().frame(height: 20 * DynamicSizeFactor.factor())
                
                HStack(spacing: 4 * DynamicSizeFactor.factor()) {
                    Button(action: {
                        toggleAllSelections()

                    }, label: {
                        Image(spendingDetails.allSatisfy { $0.isSelected } ? "icon_checkone_on_small" : "icon_checkone_off_small")
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        
                        Text("전체 선택")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                            .padding(.vertical, 4)
                    })
                    .padding(.vertical, 4)
                    .padding(.trailing, 8)
                    
                    Spacer()
                }
                .padding(.leading, 14)
                // EditNoHistorySpendingView() -> 달의 소비내역이 없으면
                
                Spacer().frame(height: 20 * DynamicSizeFactor.factor())
                
                VStack(spacing: 0) {
                    ForEach(spendingDetails.indices, id: \.self) { index in
                        HStack(spacing: 0) {
                            Button(action: {
                                spendingDetails[index].isSelected.toggle()
                            }) {
                                Image(spendingDetails[index].isSelected ? "icon_checkone_on_small" : "icon_checkone_off_small")
                                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                    .aspectRatio(contentMode: .fill)
                            }
                            
                            Image(spendingDetails[index].icon)
                                .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                .aspectRatio(contentMode: .fill)
                                .padding(.leading, 4 * DynamicSizeFactor.factor())
                            
                            VStack(alignment: .leading, spacing: 1 * DynamicSizeFactor.factor()) {
                                Text(spendingDetails[index].category)
                                    .font(.B1SemiboldeFont())
                                    .platformTextColor(color: Color("Gray06"))
                                
                                if !spendingDetails[index].description.isEmpty {
                                    Text(spendingDetails[index].description)
                                        .font(.B3MediumFont())
                                        .platformTextColor(color: Color("Gray04"))
                                }
                            }
                            .padding(.leading, 10 * DynamicSizeFactor.factor())
                            
                            Spacer()
                            
                            Text(spendingDetails[index].amount)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Gray06"))
                        }
                        .padding(.leading, 14)
                        .padding(.trailing, 20)
                        
                        Spacer().frame(height: 12) // 동적 ui 적용하니 너무 커짐
                    }
                }
                .padding(.bottom, 103)
            }
            
            Spacer() // 바텀시트 높이에 따라 조건문으로 spacer()처리해야 함.
            
            CustomBottomButton(action: { isActive = true }, label: "완료", isFormValid: .constant(true))
                .padding(.bottom, 34)
        }
            
        // }
        .navigationBarColor(UIColor(named: "White01"), title: "편집하기")
        .setTabBarVisibility(isHidden: true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_close")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
//                            .padding(5)
                    })
                    .padding(.leading, 11)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        .padding(.leading, 3)
        .padding(.trailing, 5)
    }

    private func toggleAllSelections() {
        let allSelected = spendingDetails.allSatisfy { $0.isSelected }
//        spendingDetails.indices.forEach { spendingDetails[$0].isSelected = !allSelected }
        for index in spendingDetails.indices {
            spendingDetails[index].isSelected = !allSelected
        }
    }
}

#Preview {
    EditSpendingDetailView()
}
