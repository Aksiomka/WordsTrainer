//
//  CategoryItem.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
