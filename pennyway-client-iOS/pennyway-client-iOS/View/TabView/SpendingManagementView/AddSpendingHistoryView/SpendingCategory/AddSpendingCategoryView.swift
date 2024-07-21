
import SwiftUI

// MARK: - AddCategoryEntryPoint

enum AddCategoryEntryPoint {
    case create
    case modify
}

// MARK: - AddSpendingCategoryView

struct AddSpendingCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    
    @State private var maxCategoryNameCount = 8
    @State private var isFormValid = false
    let entryPoint: AddCategoryEntryPoint
    
    private var categoryName: String {
        get {
            entryPoint == .create ? viewModel.categoryName : spendingCategoryViewModel.categoryName
        }
        set {
            if entryPoint == .create {
                viewModel.categoryName = String(newValue.prefix(maxCategoryNameCount))
            } else {
                spendingCategoryViewModel.categoryName = String(newValue.prefix(maxCategoryNameCount))
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topImageView()
            categoryInputView()
            characterCountView()
            Spacer()
            CustomBottomButton(action: addAction, label: "추가하기", isFormValid: $isFormValid)
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
            SelectCategoryIconView(isPresented: $viewModel.isSelectAddCategoryViewPresented, viewModel: viewModel, spendingCategoryViewModel: spendingCategoryViewModel, entryPoint: entryPoint)
        }
    }

    @ViewBuilder
    private func topImageView() -> some View {
        Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        ZStack {
            Image(selectedCategoryIcon())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor(), alignment: .leading)
            
            Image("icon_navigationbar_write_gray_bg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                .background(Color("Gray04"))
                .clipShape(Circle())
                .offset(x: 20 * DynamicSizeFactor.factor(), y: 20 * DynamicSizeFactor.factor())
        }
        .onTapGesture {
            viewModel.isSelectAddCategoryViewPresented = true
        }
        Spacer().frame(height: 20 * DynamicSizeFactor.factor())
    }
    
    private func selectedCategoryIcon() -> String {
        switch entryPoint {
        case .create:
            return viewModel.selectedCategoryIcon?.rawValue ?? CategoryIconName(baseName: .etc, state: .on).rawValue
        case .modify:
            return spendingCategoryViewModel.selectedCategoryIcon!.rawValue
        }
    }

    @ViewBuilder
    private func categoryInputView() -> some View {
        HStack(spacing: 11 * DynamicSizeFactor.factor()) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("Gray01"))
                    .frame(height: 46 * DynamicSizeFactor.factor())
                
                Group {
                    if viewModel.categoryName.isEmpty && spendingCategoryViewModel.categoryName.isEmpty {
                        switch entryPoint {
                        case .create:
                            Text("카테고리명을 입력하세요")
                            
                        case .modify:
                            Text("\(spendingCategoryViewModel.selectedCategory!.name)")
                        }
                    }
                }.platformTextColor(color: Color("Gray03"))
                    .padding(.leading, 13 * DynamicSizeFactor.factor())
                    .font(.H4MediumFont())
                
                TextField("", text: entryPoint == .create ? $viewModel.categoryName : $spendingCategoryViewModel.categoryName)
                    .padding(.leading, 13 * DynamicSizeFactor.factor())
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                    .onChange(of: categoryName) { _ in
                        isFormValid = !categoryName.isEmpty
                    }
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func characterCountView() -> some View {
        HStack {
            Spacer()
            Text("\(categoryName.count)/\(maxCategoryNameCount)")
                .font(.B2MediumFont())
                .platformTextColor(color: Color("Gray03"))
        }
        .padding(.horizontal, 20)
        Spacer().frame(height: 4 * DynamicSizeFactor.factor())
    }

    private func addAction() {
        if !categoryName.isEmpty {
            switch entryPoint {
            case .create:
                viewModel.addSpendingCustomCategoryApi { success in
                    if success {
                        Log.debug("카테고리 생성 완료")
                        spendingCategoryViewModel.getSpendingCustomCategoryListApi { _ in
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        Log.debug("카테고리 생성 실패")
                    }
                }
            case .modify:
                spendingCategoryViewModel.selectedCategory!.name = categoryName
                spendingCategoryViewModel.selectedCategory!.icon = spendingCategoryViewModel.selectedCategoryIcon ?? spendingCategoryViewModel.selectedCategory!.icon
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    AddSpendingCategoryView(viewModel: AddSpendingHistoryViewModel(), spendingCategoryViewModel: SpendingCategoryViewModel(), entryPoint: .create)
}
