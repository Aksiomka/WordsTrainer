//
//  CategoryListViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation
import RealmSwift

class CategoryListViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var startTrainingButtonDisabled = true
    @Published var startRevisingButtonDisabled = true
    
    private let categoryDao: CategoryDaoProtocol
    private let wordDao: WordDaoProtocol
    private let trainingSettingsStorage: TrainingSettingsStorageProtocol
    private var categoriesNotificationToken: NotificationToken?
    private var wordsNotificationToken: NotificationToken?
    
    init(
        categoryDao: CategoryDaoProtocol,
        wordDao: WordDaoProtocol,
        trainingSettingsStorage: TrainingSettingsStorageProtocol
    ) {
        self.categoryDao = categoryDao
        self.wordDao = wordDao
        self.trainingSettingsStorage = trainingSettingsStorage
    }
    
    func onAppear() {
        loadData()
        categoriesNotificationToken = categoryDao.observeCategoriesChanges { [weak self] in
            self?.loadData()
        }
        wordsNotificationToken = wordDao.observeWordsChanges { [weak self] in
            self?.loadData()
        }
    }
    
    func onDisappear() {
        categoriesNotificationToken?.invalidate()
        wordsNotificationToken?.invalidate()
    }
    
    func deleteCategories(indexes: IndexSet) {
        for index in indexes {
            if index >= categories.count {
                continue
            }
            
            let category = categories[index]
            categoryDao.deleteCategory(id: category.id)
            wordDao.deleteWordsFromCategory(categoryId: category.id)
        }
    }
}

private extension CategoryListViewModel {
    func loadData() {
        let categoriesFromDB = categoryDao.getCategories()
        categories = categoriesFromDB.map { categoryItem in
            Category(id: categoryItem.id, name: categoryItem.name)
        }
        
        let trainingSettings = trainingSettingsStorage.loadSettings()
        let numberOfLearnedWords = wordDao.countWords(
            categoryId: nil,
            filter: .learned,
            trainingSettings: trainingSettings
        )
        let numberOfWordsForTraining = wordDao.countWords(
            categoryId: nil,
            filter: .notLearned,
            trainingSettings: trainingSettings
        )
        startTrainingButtonDisabled = numberOfWordsForTraining < trainingSettings.numberOfSteps
        startRevisingButtonDisabled = numberOfLearnedWords < trainingSettings.numberOfSteps
    }
}
