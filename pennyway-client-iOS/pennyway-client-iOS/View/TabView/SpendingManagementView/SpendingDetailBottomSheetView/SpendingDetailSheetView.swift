
import SwiftUI

// MARK: - SpendingDetail

struct SpendingDetail: Identifiable {
    let id = UUID()
    let category: String
    let description: String
    let amount: String
    let icon: String
    var isSelected: Bool = false
}

// MARK: - SpendingDetailSheetView

struct SpendingDetailSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showEditSpendingDetailView = false
    @State private var showAddSpendingHistoryView = false
    @State var showingClosePopUp = false
    @State var showingDeletePopUp = false

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
        ZStack(alignment: .leading) {
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
                        
                    Button(action: {
                        showEditSpendingDetailView = true
                    }, label: {
                        Image("icon_navigationbar_write_gray05")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            
                    })
                    .padding(10)
                        
                    Button(action: {
                        showAddSpendingHistoryView = true
                    }, label: {
                        Image("icon_navigation_add")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 34, height: 34)
                            
                    })
                }
                .padding(.trailing, 17)
                .padding(.top, 12)
                
//                NoSpendingHistorySheetView() //소비내역 없을 경우
                ScrollView {
                    VStack(alignment: .leading) {
                        Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                        
                        Text("-10,000")
                            .font(.H1SemiboldFont())
                            .platformTextColor(color: Color("Gray07"))
                        
                        Spacer().frame(height: 32 * DynamicSizeFactor.factor())
                        
                        ForEach(spendingDetails) { detail in
                            HStack(spacing: 0) {
                                Image(detail.icon)
                                    .resizable()
                                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                    .aspectRatio(contentMode: .fill)
                                    .padding(.leading, 4 * DynamicSizeFactor.factor())

                                VStack(alignment: .leading, spacing: 1 * DynamicSizeFactor.factor()) {
                                    Text(detail.category)
                                        .font(.B1SemiboldeFont())
                                        .platformTextColor(color: Color("Gray06"))
                                                            
                                    if !detail.description.isEmpty {
                                        Text(detail.description)
                                            .font(.B3MediumFont())
                                            .platformTextColor(color: Color("Gray04"))
                                    }
                                }
                                .padding(.leading, 10 * DynamicSizeFactor.factor())
                                                        
                                Spacer()
                                                        
                                Text(detail.amount)
                                    .font(.B1SemiboldeFont())
                                    .platformTextColor(color: Color("Gray06"))
                                    .padding(.trailing, 20)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showEditSpendingDetailView) {
                NavigationView {
                    EditSpendingDetailView(showingDeletePopUp: $showingDeletePopUp, showingClosePopUp: $showingClosePopUp)
                }
            }
            .fullScreenCover(isPresented: $showAddSpendingHistoryView) {
                NavigationView {
                    AddSpendingHistoryView()
                }
            }
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
        .setTabBarVisibility(isHidden: true)
        .padding(.leading, 20)
    }
}

#Preview {
    SpendingDetailSheetView()
}
