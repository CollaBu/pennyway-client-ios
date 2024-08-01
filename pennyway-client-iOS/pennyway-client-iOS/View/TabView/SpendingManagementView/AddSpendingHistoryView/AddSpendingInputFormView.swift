
import SwiftUI

// MARK: - AddSpendingInputFormView

struct AddSpendingInputFormView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel

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
            AmountInputView(viewModel: viewModel, title: titleCustomTextList[0], placeholder: "소비 금액을 작성해 주세요", baseAttribute: baseAttribute, stringAttribute: stringAttribute)
                .onAppear {
                    if entryPoint == .detailSpendingView, let clickDate = clickDate {
                        if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                            viewModel.amountSpentText = String(spendingDetail.amount)
                            spendingId = spendingDetail.id
                            viewModel.selectedCategory = SpendingCategoryData(
                                id: spendingDetail.category.id,
                                isCustom: spendingDetail.category.isCustom,
                                name: spendingDetail.category.name,
                                icon: convertToSpendingCategoryData(from: spendingDetail.category)?.icon ?? CategoryIconName(baseName: .etc, state: .on)
                            )
                            viewModel.consumerText = spendingDetail.accountName
                            viewModel.memoText = spendingDetail.memo
                            viewModel.validateForm()
                        }
                    } else {
                        if let spendingDetail = spendingCategoryViewModel.dailyDetailSpendings.first {
//                        if let spendingDetail = spendingCategoryViewModel.getSpendingDetail(by: spendingId) {
                            viewModel.amountSpentText = String(spendingDetail.amount)
                            spendingId = spendingDetail.id
                            viewModel.selectedCategory = SpendingCategoryData(
                                id: spendingDetail.category.id,
                                isCustom: spendingDetail.category.isCustom,
                                name: spendingDetail.category.name,
                                icon: convertToSpendingCategoryData(from: spendingDetail.category)?.icon ?? CategoryIconName(baseName: .etc, state: .on)
                            )
                            viewModel.clickDate = DateFormatterUtil.dateFromString(spendingDetail.spendAt)
                            viewModel.consumerText = spendingDetail.accountName
                            viewModel.memoText = spendingDetail.memo
                            viewModel.validateForm()
                        }
                    }
                }
            
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
                    Text(Date.getFormattedDate(from: (clickDate ?? viewModel.clickDate) ?? viewModel.selectedDate))
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
            
            // 소비처
            CustomInputView(inputText: $viewModel.consumerText, titleText: "소비처", placeholder: "카페인 수혈, 주식투자 등등", isSecureText: false, isCustom: true)

            Spacer().frame(height: 28 * DynamicSizeFactor.factor())
            
            // 메모
            MemoInputView(memoText: $viewModel.memoText, title: "메모", placeholder: "더 하고 싶은 말이 있나요?", maxCharacterCount: maxCharacterCount)

            Spacer().frame(height: 15 * DynamicSizeFactor.factor())
        }
    }

    func convertToSpendingCategoryData(from spendingCategory: SpendingCategory) -> SpendingCategoryData? {
        guard let iconList = SpendingCategoryIconList(rawValue: spendingCategory.icon) else {
            return nil
        }
        return SpendingCategoryData(id: spendingCategory.id, isCustom: spendingCategory.isCustom, name: spendingCategory.name, icon: iconList.details.icon)
    }
}
