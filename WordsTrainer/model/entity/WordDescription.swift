//
//  WordDescription.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 15.01.2022.
//

import Foundation

struct WordDescription: Hashable {
    let word: String
    let phonetic: String
    let partOfSpeech: String
    let definition: String
    let example: String
    let synonyms: [String]
}
