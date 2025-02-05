//
//  ShareSpendingListView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 2/4/25.
//

import SwiftUI

// MARK: - ShareSpendingListView

struct ShareSpendingListView: View {
    let spendings: [SpendingItemToChat]

    var body: some View {
        ScrollView {
            VStack(spacing: 12 * DynamicSizeFactor.factor()) {
                Spacer().frame(height: 6 * DynamicSizeFactor.factor())

                ForEach(spendings, id: \.name) { spending in
                    HStack {
                        if let icon = categoryBaseName(from: spending.icon) {
                            Image("icon_category_\(icon)_on")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                        }

                        Spacer().frame(width: 10 * DynamicSizeFactor.factor())

                        Text(spending.name)
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: .gray06)

                        Spacer()

                        Text("\(spending.amount)원")
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: .gray06)
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
        }
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .background(Color(.white01))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }

    private func categoryBaseName(from icon: String) -> CategoryBaseName? {
        return SpendingCategoryIconList.allCases.first { $0.rawValue == icon }?.baseName
    }
}
