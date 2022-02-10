//
//  AddCategoryViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 12.01.2022.
//

import Foundation

class AddCategoryViewModel: ObservableObject {
    @Published var name = "" {
        didSet {
            validate()
        }
    }
    @Published var saveButtonDisabled = true
    
    private let categoryDao: CategoryDaoProtocol
    
    init(categoryDao: CategoryDaoProtocol) {
        self.categoryDao = categoryDao
    }
    
    func saveCategory() {
        categoryDao.addCategory(name: name)
    }
    
    func validate() {
        let valid = name.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        saveButtonDisabled = !valid
    }
}
