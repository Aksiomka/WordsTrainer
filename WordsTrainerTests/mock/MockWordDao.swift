//
//  MockWordDao.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 30.01.2022.
//

import Foundation
import RealmSwift
@testable import WordsTrainer

class MockWordDao: WordDaoProtocol {
    var words: [WordItem] = []
    var word: WordItem?
    var wordsCount: Int?
    var usedWordsFilter: (Int?, Filter, Sorting)?
    var addedWord: Word?
    var deletedWordId: Int?
    var deletedWordsCategoryId: Int?
    var updatedWordId: Int?
    
    func addWord(
        categoryId: Int,
        word: String,
        definition: String,
        phonetic: String,
        example: String,
        partOfSpeech: String,
        synonyms: String
    ) {
        addedWord = Word(
            id: 0,
            categoryId: categoryId,
            word: word,
            definition: definition,
            phonetic: phonetic,
            example: example,
            partOfSpeech: partOfSpeech,
            synonyms: synonyms,
            rightAnswers: 0
        )
    }
    
    func getWords(
        categoryId: Int?,
        filter: Filter,
        sorting: Sorting,
        trainingSettings: TrainingSettings
    ) -> [WordItem] {
        usedWordsFilter = (categoryId, filter, sorting)
        return words
    }
    
    func getWordById(_ id: Int) -> WordItem? {
        return word
    }
    
    func getWordByIds(_ ids: [Int]) -> [WordItem] {
        return words
    }
    
    func getRandomNotLearnedWord(trainingSettings: TrainingSettings) -> WordItem? { return nil }
    
    func countWords(categoryId: Int?, filter: Filter, trainingSettings: TrainingSettings) -> Int {
        return wordsCount ?? 0
    }
    
    func incrementWordRightAnswers(id: Int) {
        updatedWordId = id
    }
    
    func deleteWord(id: Int) {
        deletedWordId = id
    }
    
    func deleteWordsFromCategory(categoryId: Int) {
        deletedWordsCategoryId = categoryId
    }
    
    func observeWordsChanges(callback: @escaping () -> Void) -> NotificationToken? {
        return nil
    }
}
