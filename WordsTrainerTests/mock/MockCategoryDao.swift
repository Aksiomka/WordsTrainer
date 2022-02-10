//
//  MockCategoryDao.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 29.01.2022.
//

import Foundation
import RealmSwift
@testable import WordsTrainer

class MockCategoryDao: CategoryDaoProtocol {
    var categories: [CategoryItem] = []
    var category: CategoryItem?
    var addedCategoryName = ""
    var deletedCategoryId: Int?
    
    func addCategory(name: String) {
        addedCategoryName = name
    }
    
    func getCategories() -> [CategoryItem] {
        return categories
    }
    
    func getCategoryById(_ id: Int) -> CategoryItem? {
        return category
    }
    
    func deleteCategory(id: Int) {
        deletedCategoryId = id
    }
    
    func observeCategoriesChanges(callback: @escaping () -> Void) -> NotificationToken? {
        return nil
    }
}
