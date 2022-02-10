//
//  WordDao.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation
import RealmSwift

protocol WordDaoProtocol {
    func addWord(
        categoryId: Int,
        word: String,
        definition: String,
        phonetic: String,
        example: String,
        partOfSpeech: String,
        synonyms: String
    )
    func getWords(
        categoryId: Int?,
        filter: Filter,
        sorting: Sorting,
        trainingSettings: TrainingSettings
    ) -> [WordItem]
    func getWordById(_ id: Int) -> WordItem?
    func getWordByIds(_ ids: [Int]) -> [WordItem]
    func getRandomNotLearnedWord(trainingSettings: TrainingSettings) -> WordItem?
    func countWords(categoryId: Int?, filter: Filter, trainingSettings: TrainingSettings) -> Int
    func incrementWordRightAnswers(id: Int)
    func deleteWord(id: Int)
    func deleteWordsFromCategory(categoryId: Int)
    func observeWordsChanges(callback: @escaping () -> Void) -> NotificationToken?
}

class WordDao: WordDaoProtocol {
    func addWord(
        categoryId: Int,
        word: String,
        definition: String,
        phonetic: String,
        example: String,
        partOfSpeech: String,
        synonyms: String
    ) {
        let realm = Realm.getInstance()
        let wordItem = WordItem()
        wordItem.categoryId = categoryId
        wordItem.word = word
        wordItem.definition = definition
        wordItem.phonetic = phonetic
        wordItem.example = example
        wordItem.partOfSpeech = partOfSpeech
        wordItem.synonyms = synonyms
        try! realm.write {
            let maxId = realm.objects(WordItem.self).max(ofProperty: "id") as Int? ?? 0
            wordItem.id = maxId + 1
            realm.add(wordItem, update: .modified)
        }
    }
    
    func getWords(
        categoryId: Int?,
        filter: Filter,
        sorting: Sorting,
        trainingSettings: TrainingSettings
    ) -> [WordItem] {
        let realm = Realm.getInstance()
        var objects = realm.objects(WordItem.self)
        objects = applyWordsFilter(
            results: objects,
            categoryId: categoryId,
            filter: filter,
            trainingSettings: trainingSettings
        )
        switch sorting {
        case .alphabetically:
            objects = objects.sorted(byKeyPath: "word")
        case .byProgress:
            objects = objects.sorted(byKeyPath: "rightAnswers")
        }
        return Array(objects)
    }
    
    func getWordById(_ id: Int) -> WordItem? {
        let realm = Realm.getInstance()
        return realm.object(ofType: WordItem.self, forPrimaryKey: id)
    }
    
    func getWordByIds(_ ids: [Int]) -> [WordItem] {
        let idsStr = ids.map { String($0) }.joined(separator: ",")
        let realm = Realm.getInstance()
        return Array(realm.objects(WordItem.self).filter("id IN {\(idsStr)}").sorted(byKeyPath: "word"))
    }
    
    func getRandomNotLearnedWord(trainingSettings: TrainingSettings) -> WordItem? {
        let realm = Realm.getInstance()
        let words = realm.objects(WordItem.self).filter("rightAnswers < %d", trainingSettings.learnedWordBound)
        let wordsCount = words.count
        guard wordsCount > 0 else {
            return nil
        }
        let randomId = Int.random(in: 0 ..< wordsCount)
        return words[randomId]
    }
    
    func countWords(categoryId: Int?, filter: Filter, trainingSettings: TrainingSettings) -> Int {
        let realm = Realm.getInstance()
        var objects = realm.objects(WordItem.self)
        objects = applyWordsFilter(
            results: objects,
            categoryId: categoryId,
            filter: filter,
            trainingSettings: trainingSettings
        )
        return objects.count
    }
    
    func incrementWordRightAnswers(id: Int) {
        let realm = Realm.getInstance()
        try! realm.write {
            if let wordItem = getWordById(id) {
                wordItem.rightAnswers += 1
                realm.add(wordItem, update: .modified)
            }
        }
    }
    
    func deleteWord(id: Int) {
        let realm = Realm.getInstance()
        try! realm.write {
            if let wordItem = getWordById(id) {
                realm.delete(wordItem)
            }
        }
    }
    
    func deleteWordsFromCategory(categoryId: Int) {
        let realm = Realm.getInstance()
        let objects = realm.objects(WordItem.self).filter("categoryId == %d", categoryId)
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    func observeWordsChanges(callback: @escaping () -> Void) -> NotificationToken? {
        let realm = Realm.getInstance()
        return realm.objects(WordItem.self).observe { _ in
            callback()
        }
    }
}

private extension WordDao {
    func applyWordsFilter(
        results: Results<WordItem>,
        categoryId: Int?,
        filter: Filter,
        trainingSettings: TrainingSettings
    ) -> Results<WordItem> {
        var newResults = results
        if let categoryId = categoryId {
            newResults = newResults.filter("categoryId == %d", categoryId)
        }
        switch filter {
        case .learned:
            newResults = newResults.filter("rightAnswers >= %d", trainingSettings.learnedWordBound)
        case .notLearned:
            newResults = newResults.filter("rightAnswers < %d", trainingSettings.learnedWordBound)
        case .halfLearned:
            newResults = newResults.filter(
                "rightAnswers >= %d and rightAnswers < %d",
                trainingSettings.learnedWordBound / 2,
                trainingSettings.learnedWordBound
            )
        case .new:
            newResults = newResults.filter("rightAnswers < %d", trainingSettings.learnedWordBound / 2)
        case .all:
            break
        }
        return newResults
    }
}
