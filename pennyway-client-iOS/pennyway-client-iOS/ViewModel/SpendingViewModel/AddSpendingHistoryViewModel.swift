//
//  AddSpendingHistoryViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 5/22/24.
//

import SwiftUI

class AddSpendingHistoryViewModel: ObservableObject {
    @Published var memoText: String = ""
    @Published var isCategoryListViewPresented: Bool = false
    @Published var selectedCategory: (String, String)? = nil

    @Published var isSelectDayViewPresented: Bool = false
    @Published var selectedDate: Date = Date()
}
