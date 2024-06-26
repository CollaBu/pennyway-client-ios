import SwiftUI

// MARK: - EditSpendingDetailView

struct EditSpendingDetailView: View {
    @State var showingDeletePopUp = false
    @State var showingClosePopUp = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isItemSelected: Bool = false

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
        ZStack {
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
                                    updateSelectionState()
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
                    
                CustomBottomButton(action: {
                    if isItemSelected {
                        showingDeletePopUp = true
                        Log.debug("showingDeletePopUp: \(showingDeletePopUp)")
                    }
                        
                }, label: "삭제하기", isFormValid: $isItemSelected)
                    .padding(.bottom, 34)
            }
            .padding(.leading, 3)
            .padding(.trailing, 5)
                
            if showingClosePopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingClosePopUp,
                                titleLabel: "편집을 끝낼까요?",
                                subTitleLabel: "변경된 내용은 자동 저장돼요",
                                firstBtnAction: { self.showingClosePopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: { self.presentationMode.wrappedValue.dismiss() },
                                secondBtnLabel: "끝낼래요",
                                secondBtnColor: Color("Mint03")
                )
            }
            
            if showingDeletePopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingDeletePopUp,
                                titleLabel: "8개의 내역을 삭제할까요?",
                                subTitleLabel: "선택한 소비 내역이 사라져요",
                                firstBtnAction: { self.showingDeletePopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: { self.presentationMode.wrappedValue.dismiss() },
                                secondBtnLabel: "삭제하기",
                                secondBtnColor: Color("Red03")
                )
            }
        }
        .navigationBarTitle("편집하기", displayMode: .inline)
        .setTabBarVisibility(isHidden: true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        showingClosePopUp = true
                        Log.debug("showingClosePopUp: \(showingClosePopUp)")
                    }, label: {
                        Image("icon_close")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                    })
                    .padding(.leading, 11)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }
    
    private func toggleAllSelections() {
        let allSelected = spendingDetails.allSatisfy { $0.isSelected }
        for index in spendingDetails.indices {
            spendingDetails[index].isSelected = !allSelected
        }
        updateSelectionState()
    }
    
    private func updateSelectionState() {
        isItemSelected = spendingDetails.contains { $0.isSelected }
    }
}

#Preview {
    EditSpendingDetailView()
}
