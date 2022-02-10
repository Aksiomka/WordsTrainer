//
//  WordApiModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 15.01.2022.
//

import Foundation

struct WordApiModel: Decodable, Equatable {
    let word: String
    let phonetics: [Phonetics]
    let meanings: [Meaning]
}

struct Phonetics: Decodable, Equatable {
    let text: String?
    let audio: String?
}

struct Meaning: Decodable, Equatable {
    let partOfSpeech: String?
    let definitions: [Definition]
}

struct Definition: Decodable, Equatable {
    let definition: String?
    let example: String?
    let synonyms: [String]
}
