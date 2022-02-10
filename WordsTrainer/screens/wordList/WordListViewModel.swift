//
//  WordListViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation
import RealmSwift

class WordListViewModel: ObservableObject {
    @Published var words: [WordRowInfo] = []
    @Published var categoryId: Int
    @Published var startTrainingButtonDisabled = true
    @Published var startRevisingButtonDisabled = true
    
    private let wordDao: WordDaoProtocol
    private let wordListSettingsStorage: WordListSettingsStorageProtocol
    private let trainingSettingsStorage: TrainingSettingsStorageProtocol
    private var wordsNotificationToken: NotificationToken?
    
    init(
        categoryId: Int,
        wordDao: WordDaoProtocol,
        wordListSettingsStorage: WordListSettingsStorageProtocol,
        trainingSettingsStorage: TrainingSettingsStorageProtocol
    ) {
        self.categoryId = categoryId
        self.wordDao = wordDao
        self.wordListSettingsStorage = wordListSettingsStorage
        self.trainingSettingsStorage = trainingSettingsStorage
    }
    
    func onAppear() {
        loadData()
        wordsNotificationToken = wordDao.observeWordsChanges { [weak self] in
            self?.loadData()
        }
    }
    
    func onDisappear() {
        wordsNotificationToken?.invalidate()
    }
    
    func deleteWords(indexes: IndexSet) {
        for index in indexes {
            if index >= words.count {
                continue
            }
            
            let word = words[index]
            wordDao.deleteWord(id: word.id)
        }
    }
    
    func onSortingChanged(sorting: Sorting) {
        wordListSettingsStorage.saveSorting(sorting)
        loadData()
    }
    
    func onFilterChanged(filter: Filter) {
        wordListSettingsStorage.saveFilter(filter)
        loadData()
    }
}

private extension WordListViewModel {
    func loadData() {
        let trainingSettings = trainingSettingsStorage.loadSettings()
        let sorting = wordListSettingsStorage.loadSorting()
        let filter = wordListSettingsStorage.loadFilter()
        
        let wordsFromDB = wordDao.getWords(
            categoryId: categoryId,
            filter: filter,
            sorting: sorting,
            trainingSettings: trainingSettings
        )
        words = wordsFromDB.map { wordItem in
            WordRowInfo(
                id: wordItem.id,
                word: wordItem.word,
                definition: wordItem.definition,
                wordStatus: WordStatus.create(rightAnswers: wordItem.rightAnswers, trainingSettings: trainingSettings)
            )
        }
        
        let numberOfLearnedWords = wordDao.countWords(
            categoryId: categoryId,
            filter: .learned,
            trainingSettings: trainingSettings
        )
        let numberOfWordsForTraining = wordDao.countWords(
            categoryId: categoryId,
            filter: .notLearned,
            trainingSettings: trainingSettings
        )
        startTrainingButtonDisabled = numberOfWordsForTraining < trainingSettings.numberOfSteps
        startRevisingButtonDisabled = numberOfLearnedWords < trainingSettings.numberOfSteps
    }
}
