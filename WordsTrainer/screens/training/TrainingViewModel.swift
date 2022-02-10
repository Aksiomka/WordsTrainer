//
//  TrainingViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

enum TrainingButtonType {
    case next
    case finish
}

protocol TrainingViewModelProtocol {
    func loadData()
    func answerChosen(answer: TrainingAnswer)
    func nextTapped()
}

class TrainingViewModel: ObservableObject {
    @Published var stepNumber = 0
    @Published var definition = ""
    @Published var answers: [TrainingAnswer] = []
    @Published var answerButtonsDisabled = false
    @Published var nextButtonDisabled = false
    @Published var buttonType: TrainingButtonType = .next
    
    private let trainingType: TrainingType
    private var trainingInfo = TrainingInfo(words: [])
    private var numberOfRightAnswers = 0
    
    private let wordDao: WordDaoProtocol
    private let trainingInfoMaker: TrainingInfoMakerProtocol
    private let trainingSettings: TrainingSettings
    
    init(
        trainingType: TrainingType,
        wordDao: WordDaoProtocol,
        trainingInfoMaker: TrainingInfoMakerProtocol,
        trainingSettingsStorage: TrainingSettingsStorageProtocol
    ) {
        self.trainingType = trainingType
        self.wordDao = wordDao
        self.trainingInfoMaker = trainingInfoMaker
        self.trainingSettings = trainingSettingsStorage.loadSettings()
    }
}

extension TrainingViewModel: TrainingViewModelProtocol {
    func loadData() {
        let wordsFromDb = fetchWords()
        let convertedWordsFromDb = wordsFromDb.map { wordInfo in
            return Word(
                id: wordInfo.id,
                categoryId: wordInfo.categoryId,
                word: wordInfo.word,
                definition: wordInfo.definition,
                phonetic: wordInfo.phonetic,
                example: wordInfo.example,
                partOfSpeech: wordInfo.partOfSpeech,
                synonyms: wordInfo.synonyms,
                rightAnswers: wordInfo.rightAnswers
            )
        }
        trainingInfo = trainingInfoMaker.makeTrainingInfo(
            words: convertedWordsFromDb,
            trainingSettings: trainingSettings
        )
        
        stepNumber = 0
        initTrainingStep()
    }
    
    func answerChosen(answer: TrainingAnswer) {
        if answer.correct {
            numberOfRightAnswers += 1
            let wordId = trainingInfo.words[stepNumber - 1].wordId
            wordDao.incrementWordRightAnswers(id: wordId)
        }
        answerButtonsDisabled = true
        nextButtonDisabled = false
    }
    
    func nextTapped() {
        initTrainingStep()
    }
    
    func createTrainingResult() -> TrainingResult {
        let wordIds = trainingInfo.words.map { $0.wordId }
        return TrainingResult(wordIds: wordIds, numberOfRightAnswers: numberOfRightAnswers)
    }
}

private extension TrainingViewModel {
    func fetchWords() -> [WordItem] {
        var trainingCategoryId: Int? = nil
        let filter: Filter
        switch trainingType {
        case .learningAll:
            filter = .notLearned
        case .learning(let categoryId):
            trainingCategoryId = categoryId
            filter = .notLearned
        case .revisingAll:
            filter = .learned
        case .revising(let categoryId):
            trainingCategoryId = categoryId
            filter = .learned
        }
        return wordDao.getWords(
            categoryId: trainingCategoryId,
            filter: filter,
            sorting: .alphabetically,
            trainingSettings: trainingSettings
        )
    }
    
    func initTrainingStep() {
        stepNumber += 1
        
        let wordInfo = trainingInfo.words[stepNumber - 1]
        definition = wordInfo.definition
        answers = wordInfo.answers
        
        answerButtonsDisabled = false
        nextButtonDisabled = true
        buttonType = stepNumber >= trainingSettings.numberOfSteps ? .finish : .next
    }
}
