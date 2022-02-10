//
//  WordItem+Extension.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 30.01.2022.
//

import Foundation
@testable import WordsTrainer

extension WordItem {
    static func createWordItem(id: Int, categoryId: Int, word: String, rightAnswers: Int) -> WordItem {
        let wordItem = WordItem()
        wordItem.id = id
        wordItem.categoryId = categoryId
        wordItem.word = word
        wordItem.definition = "definition of \(word)"
        wordItem.phonetic = word
        wordItem.partOfSpeech = "noun"
        wordItem.rightAnswers = rightAnswers
        return wordItem
    }
    
    static func createWordItem(id: Int, word: String, rightAnswers: Int) -> WordItem {
        let wordItem = WordItem()
        wordItem.id = id
        wordItem.categoryId = 0
        wordItem.word = word
        wordItem.definition = "definition of \(word)"
        wordItem.rightAnswers = rightAnswers
        return wordItem
    }
}
