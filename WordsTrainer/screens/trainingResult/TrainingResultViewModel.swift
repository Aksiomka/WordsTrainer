//
//  TrainingResultViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

class TrainingResultViewModel: ObservableObject {
    @Published var rightAnswers = 0
    @Published var wrongAnswers = 0
    @Published var words: [WordRowInfo] = []
    
    private let trainingResult: TrainingResult
    private let wordDao: WordDaoProtocol
    private let trainingSettingsStorage: TrainingSettingsStorageProtocol

    init(trainingResult: TrainingResult, wordDao: WordDaoProtocol, trainingSettingsStorage: TrainingSettingsStorageProtocol) {
        self.trainingResult = trainingResult
        self.wordDao = wordDao
        self.trainingSettingsStorage = trainingSettingsStorage
        
        let trainingSettings = trainingSettingsStorage.loadSettings()
        rightAnswers = trainingResult.numberOfRightAnswers
        wrongAnswers = trainingSettings.numberOfSteps - trainingResult.numberOfRightAnswers
    }
    
    func loadWords() {
        let trainingSettings = trainingSettingsStorage.loadSettings()
        words = wordDao
            .getWordByIds(trainingResult.wordIds)
            .map {
                WordRowInfo(
                    id: $0.id,
                    word: $0.word,
                    definition: $0.definition,
                    wordStatus: WordStatus.create(rightAnswers: $0.rightAnswers, trainingSettings: trainingSettings)
                )
            }
    }
}
