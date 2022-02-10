//
//  Word+Extension.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 30.01.2022.
//

import Foundation
@testable import WordsTrainer

extension Word {
    static func createWord(id: Int, categoryId: Int, word: String, rightAnswers: Int) -> Word {
        return Word(
            id: id,
            categoryId: categoryId,
            word: word,
            definition: "definition of \(word)",
            phonetic: word,
            example: "",
            partOfSpeech: "noun",
            synonyms: "",
            rightAnswers: rightAnswers
        )
    }
    
    static func createWord(id: Int, word: String, rightAnswers: Int) -> Word {
        return createWord(id: id, categoryId: 0, word: word, rightAnswers: rightAnswers)
    }
    
    static func createWord(id: Int, word: String) -> Word {
        return createWord(id: id, word: word, rightAnswers: 0)
    }
}
