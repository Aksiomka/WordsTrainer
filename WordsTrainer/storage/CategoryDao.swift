//
//  CategoryDao.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation
import RealmSwift

protocol CategoryDaoProtocol {
    func addCategory(name: String)
    func getCategories() -> [CategoryItem]
    func getCategoryById(_ id: Int) -> CategoryItem?
    func deleteCategory(id: Int)
    func observeCategoriesChanges(callback: @escaping () -> Void) -> NotificationToken?
}

class CategoryDao: CategoryDaoProtocol {
    func addCategory(name: String) {
        let realm = Realm.getInstance()
        let categoryItem = CategoryItem()
        categoryItem.name = name
        try! realm.write {
            let maxId = realm.objects(CategoryItem.self).max(ofProperty: "id") as Int? ?? 0
            categoryItem.id = maxId + 1
            realm.add(categoryItem, update: .modified)
        }
    }
    
    func getCategories() -> [CategoryItem] {
        let realm = Realm.getInstance()
        return Array(realm.objects(CategoryItem.self).sorted(byKeyPath: "name"))
    }
    
    func getCategoryById(_ id: Int) -> CategoryItem? {
        let realm = Realm.getInstance()
        return realm.object(ofType: CategoryItem.self, forPrimaryKey: id)
    }
    
    func deleteCategory(id: Int) {
        let realm = Realm.getInstance()
        try! realm.write {
            if let categoryItem = getCategoryById(id) {
                realm.delete(categoryItem)
            }
        }
    }
    
    func observeCategoriesChanges(callback: @escaping () -> Void) -> NotificationToken? {
        let realm = Realm.getInstance()
        return realm.objects(CategoryItem.self).observe { _ in
            callback()
        }
    }
}
