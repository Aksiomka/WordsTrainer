//
//  WordItem.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation
import RealmSwift

class WordItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var categoryId = 0
    @objc dynamic var word = ""
    @objc dynamic var definition = ""
    @objc dynamic var phonetic = ""
    @objc dynamic var partOfSpeech = ""
    @objc dynamic var example = ""
    @objc dynamic var synonyms = ""
    @objc dynamic var rightAnswers = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
