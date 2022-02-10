//
//  Word.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

struct Word: Equatable {
    let id: Int
    let categoryId: Int
    let word: String
    let definition: String
    let phonetic: String
    let example: String
    let partOfSpeech: String
    let synonyms: String
    let rightAnswers: Int
    
    static func createEmptyWord() -> Word {
        Word(
            id: 0,
            categoryId: 0,
            word: "",
            definition: "",
            phonetic: "",
            example: "",
            partOfSpeech: "",
            synonyms: "",
            rightAnswers: 0
        )
    }
}
