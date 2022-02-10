//
//  AddWordViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

class AddWordViewModel: ObservableObject {
    @Published var word = "" {
        didSet {
            validate()
        }
    }
    @Published var definition = "" {
        didSet {
            validate()
        }
    }
    @Published var phonetic = "" {
        didSet {
            validate()
        }
    }
    @Published var partOfSpeech = "" {
        didSet {
            validate()
        }
    }
    @Published var example = "" {
        didSet {
            validate()
        }
    }
    @Published var synonyms = "" {
        didSet {
            validate()
        }
    }
    @Published var saveButtonDisabled = true
    
    private let categoryId: Int
    private let wordDao: WordDaoProtocol
    
    init(categoryId: Int, wordDescription: WordDescription, wordDao: WordDaoProtocol) {
        self.categoryId = categoryId
        self.word = wordDescription.word
        self.definition = wordDescription.definition
        self.phonetic = wordDescription.phonetic
        self.partOfSpeech = wordDescription.partOfSpeech
        self.example = wordDescription.example
        self.synonyms = wordDescription.synonyms.joined(separator: ", ")
        self.wordDao = wordDao
        validate()
    }
    
    func saveWord() {
        wordDao.addWord(
            categoryId: categoryId,
            word: word,
            definition: definition,
            phonetic: phonetic,
            example: example,
            partOfSpeech: partOfSpeech,
            synonyms: synonyms
        )
    }
    
    func validate() {
        let valid = word.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
            definition.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        saveButtonDisabled = !valid
    }
}
