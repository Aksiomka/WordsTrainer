//
//  CategoryItem+Extension.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 30.01.2022.
//

import Foundation
@testable import WordsTrainer

extension CategoryItem {
    static func createCategoryItem(id: Int, name: String) -> CategoryItem {
        let categoryItem = CategoryItem()
        categoryItem.id = id
        categoryItem.name = name
        return categoryItem
    }
}
