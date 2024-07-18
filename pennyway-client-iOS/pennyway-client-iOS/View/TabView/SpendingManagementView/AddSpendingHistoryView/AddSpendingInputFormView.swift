
import SwiftUI

// MARK: - AddSpendingInputFormView

struct AddSpendingInputFormView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

    @Binding var clickDate: Date?
    var entryPoint: EntryPoint
    @Binding var spendingId: Int

    let baseAttribute: BaseAttribute = BaseAttribute(font: .B1MediumFont(), color: Color("Gray07"))
    let stringAttribute: StringAttribute = StringAttribute(text: "*", font: .B1MediumFont(), color: Color("Mint03"))
    
    let titleCustomTextList: [String] = ["금액*", "카테고리*", "날짜*"]
    let maxCharacterCount: Int = 100

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 31 * DynamicSizeFactor.factor())
            
            VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
                titleCustomTextList[0].toAttributesText(base: baseAttribute, stringAttribute)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46 * DynamicSizeFactor.factor())
                        
                        if viewModel.amountSpentText.isEmpty {
                            Text("소비 금액을 작성해 주세요")
                                .platformTextColor(color: Color("Gray03"))
                                .padding(.leading, 13 * DynamicSizeFactor.factor())
                                .font(.H4MediumFont())
                        }
                        
                        TextField("", text: $viewModel.amountSpentText)
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                            .keyboardType(.numberPad)
                            .platformTextColor(color: Color("Gray07"))
                            .onChange(of: viewModel.amountSpentText) { _ in
                                viewModel.amountSpentText = NumberFormatterUtil.formatStringToDecimalString(viewModel.amountSpentText)
                                viewModel.validateForm()
                            }
                            .onAppear {
                                if entryPoint == .detailSpendingView, let clickDate = clickDate {
                                    if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                                        viewModel.amountSpentText = String(spendingDetail.amount)
                                        spendingId = spendingDetail.id
//                                        if let baseName = CategoryBaseName(rawValue: spendingDetail.category.icon.lowercased()) {
                                        if let categoryIcon = SpendingListViewCategoryIconList(rawValue: spendingDetail.category.icon)?.iconName {
                                            viewModel.selectedCategory = SpendingCategoryData(
                                                id: spendingDetail.category.id,
                                                isCustom: spendingDetail.category.isCustom,
                                                name: spendingDetail.category.name,
                                                icon: CategoryIconName(baseName: CategoryBaseName(rawValue: categoryIcon) ?? .etc, state: .on)
                                            )
                                        }
                                        viewModel.consumerText = spendingDetail.accountName
                                        viewModel.memoText = spendingDetail.memo
                                        viewModel.validateForm()
                                        
                                        Log.debug("?: \(viewModel.amountSpentText), \(viewModel.selectedCategory)")
                                    }
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            
            // 카테고리
            HStack {
                titleCustomTextList[1].toAttributesText(base: baseAttribute, stringAttribute)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer()
                
                HStack(spacing: 0) {
                    if let category = viewModel.selectedCategory {
                        HStack {
                            Image(category.icon.rawValue)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                            
                            Text(category.name)
                                .font(.B1MediumFont())
                                .platformTextColor(color: Color("Gray07"))
                        }
                    } else {
                        if entryPoint == .detailSpendingView, let clickDate = clickDate { // 지출내역 수정하기 시 선택된 카테고리
                            if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                                HStack {
                                    let iconName = SpendingListViewCategoryIconList(rawValue: spendingDetail.category.icon)?.iconName ?? ""
                                    Image(iconName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                                    
                                    Text(spendingDetail.category.name)
                                        .font(.B1MediumFont())
                                        .platformTextColor(color: Color("Gray07"))
                                }
                            } else {
                                Text("카테고리를 선택해 주세요")
                                    .font(.B1MediumFont())
                                    .platformTextColor(color: Color("Gray04"))
                            }
                            
                        } else {
                            Text("카테고리를 선택해 주세요")
                                .font(.B1MediumFont())
                                .platformTextColor(color: Color("Gray04"))
                        }
                    }
                        
                    Image("icon_arrow_front_small")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                }
                
                .frame(alignment: .trailing)
                .padding(.leading, 12)
                .padding(.vertical, 14)
                .onTapGesture {
                    viewModel.isCategoryListViewPresented = true
                    viewModel.getSpendingCustomCategoryListApi()
                }
            }
            .padding(.horizontal, 20)
            
            // 날짜
            HStack {
                titleCustomTextList[2].toAttributesText(base: baseAttribute, stringAttribute)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text(Date.getFormattedDate(from: clickDate ?? viewModel.selectedDate))
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                   
                    Image("icon_arrow_front_small")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                }
                .frame(alignment: .trailing)
                .padding(.leading, 12)
                .padding(.vertical, 14)
            }
            .padding(.horizontal, 20)
            .onTapGesture {
                viewModel.isSelectDayViewPresented = true
                Log.debug(viewModel.selectedDate)
            }
            
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            
            CustomInputView(inputText: $viewModel.consumerText, titleText: "소비처", placeholder: "카페인 수혈, 주식투자 등등", isSecureText: false, isCustom: true)

                .onAppear {
                    if entryPoint == .detailSpendingView, let clickDate = clickDate {
                        if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                            viewModel.consumerText = spendingDetail.accountName
                        }
                    }
                }
                
            Spacer().frame(height: 28 * DynamicSizeFactor.factor())
            
            VStack(alignment: .leading) {
                Text("메모")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 104 * DynamicSizeFactor.factor())
                    
                    TextEditor(text: $viewModel.memoText)
                        .font(.H4MediumFont())
                        .padding(.horizontal, 8 * DynamicSizeFactor.factor())
                        .padding(.vertical, 5 * DynamicSizeFactor.factor())
                        .zIndex(0)
                        .colorMultiply(Color("Gray01"))
                        .cornerRadius(4)
                        .TextAutocapitalization()
                        .AutoCorrectionExtensions()
                        .onChange(of: viewModel.memoText) { _ in
                            if viewModel.memoText.count > 100 {
                                viewModel.memoText = String(viewModel.memoText.prefix(100))
                            }
                        }
                        .onAppear {
                            if entryPoint == .detailSpendingView, let clickDate = clickDate {
                                if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                                    viewModel.memoText = spendingDetail.memo
                                }
                            }
                        }
                        .frame(height: 104 * DynamicSizeFactor.factor())
                    if viewModel.memoText.isEmpty {
                        Text("더 하고 싶은 말이 있나요?")
                            .font(.H4MediumFont())
                            .padding(12 * DynamicSizeFactor.factor())
                            .platformTextColor(color: Color("Gray03"))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                
                HStack {
                    Spacer()
                    Text("\(viewModel.memoText.count)/\(maxCharacterCount)")
                        .font(.B2MediumFont())
                        .platformTextColor(color: Color("Gray03"))
                }
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 15 * DynamicSizeFactor.factor())
        }
    }
}
