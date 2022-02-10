//
//  AppViewData.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

class AppViewData: ObservableObject {
    @Published var trainingNavigationSelection: String? = nil
    @Published var addWordNavigationSelection: String? = nil
}
