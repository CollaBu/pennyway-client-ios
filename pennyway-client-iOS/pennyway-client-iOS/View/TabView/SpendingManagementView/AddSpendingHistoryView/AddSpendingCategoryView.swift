
import SwiftUI

// MARK: - AddSpendingCategoryView

struct AddSpendingCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddSpendingHistoryViewModel

    @State var maxCategoryNameCount = "8"
    @State var categoryName: String = ""

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            ZStack {
                Image(viewModel.selectedCategoryIcon ?? "icon_category_etc_on")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor(), alignment: .leading)

                Image("icon_navigationbar_write_gray")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .background(Color("Gray04"))
                    .clipShape(Circle())
                    .offset(x: 20 * DynamicSizeFactor.factor(), y: 20 * DynamicSizeFactor.factor())
            }
            .onTapGesture {
                viewModel.isSelectAddCategoryViewPresented = true
            }

            Spacer().frame(height: 20 * DynamicSizeFactor.factor())

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    if categoryName.isEmpty {
                        Text("카테고리명을 입력하세요")
                            .platformTextColor(color: Color("Gray03"))
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                    }

                    TextField("", text: $categoryName)
                        .padding(.leading, 13 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        .onChange(of: categoryName) { _ in
                            if categoryName.count > 8 {
                                categoryName = String(categoryName.prefix(8))
                            }
                            if !categoryName.isEmpty {
                                viewModel.isAddCategoryFormValid = true
                            } else {
                                viewModel.isAddCategoryFormValid = false
                            }
                        }
                }
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 4 * DynamicSizeFactor.factor())

            HStack {
                Spacer()
                Text("\(categoryName.count)/\(maxCategoryNameCount)")
                    .font(.B2MediumFont())
                    .platformTextColor(color: Color("Gray03"))
            }
            .padding(.horizontal, 20)

            Spacer()

            CustomBottomButton(action: {
                if !categoryName.isEmpty {
                    viewModel.selectedCategory = (viewModel.selectedCategoryIcon ?? "icon_category_etc_on", categoryName)
                    viewModel.validateForm()
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: "추가하기", isFormValid: $viewModel.isAddCategoryFormValid)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color("White01"))
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        .bottomSheet(isPresented: $viewModel.isSelectAddCategoryViewPresented, maxHeight: 347 * DynamicSizeFactor.factor()) {
            SelectCategoryIconView(isPresented: $viewModel.isSelectAddCategoryViewPresented, viewModel: viewModel)
        }
    }
}

#Preview {
    AddSpendingCategoryView(viewModel: AddSpendingHistoryViewModel())
}
