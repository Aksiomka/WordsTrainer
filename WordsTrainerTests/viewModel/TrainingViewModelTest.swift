//
//  TrainingViewModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 26.01.2022.
//

import XCTest
@testable import WordsTrainer

class TrainingViewModelTest: XCTestCase {
    private var mockWordDao: MockWordDao!
    private var mockTrainingInfoMaker: MockTrainingInfoMaker!
    private var mockTrainingSettingsStorage: MockTrainingSettingsStorage!
    private var wordItems: [WordItem] = [
        WordItem.createWordItem(id: 0, word: "cat", rightAnswers: 0),
        WordItem.createWordItem(id: 1, word: "dog", rightAnswers: 0)
    ]
    
    override func setUpWithError() throws {
        mockWordDao = MockWordDao()
        mockWordDao.words = wordItems
        mockTrainingInfoMaker = MockTrainingInfoMaker(
            trainingInfo: TrainingInfo(
                words: [
                    TrainingStepInfo(wordId: 0, definition: "definition of cat", answers: [
                        TrainingAnswer(answer: "cat", correct: true),
                        TrainingAnswer(answer: "dog", correct: false)
                    ]),
                    TrainingStepInfo(wordId: 1, definition: "definition of dog", answers: [
                        TrainingAnswer(answer: "cat", correct: false),
                        TrainingAnswer(answer: "dog", correct: true)
                    ])
                ]
            )
        )
        mockTrainingSettingsStorage = MockTrainingSettingsStorage(
            trainingSettings: TrainingSettings(numberOfSteps: 2, numberOfAnswers: 2, learnedWordBound: 100)
        )
    }
    
    func testLoadData_LearningAll() throws {
        let trainingViewModel = createTrainingViewModel(trainingType: .learningAll)
        trainingViewModel.loadData()
        
        XCTAssertNil(mockWordDao.usedWordsFilter?.0)
        XCTAssertEqual(Filter.notLearned, mockWordDao.usedWordsFilter?.1)
        XCTAssertEqual(1, trainingViewModel.stepNumber)
        XCTAssertEqual("definition of cat", trainingViewModel.definition)
        XCTAssertEqual([TrainingAnswer(answer: "cat", correct: true), TrainingAnswer(answer: "dog", correct: false)],
                       trainingViewModel.answers)
        XCTAssertFalse(trainingViewModel.answerButtonsDisabled)
        XCTAssertTrue(trainingViewModel.nextButtonDisabled)
        XCTAssertEqual(TrainingButtonType.next, trainingViewModel.buttonType)
        XCTAssertEqual(0, trainingViewModel.createTrainingResult().numberOfRightAnswers)
    }
    
    func testLoadData_RevisingCategory() throws {
        let trainingViewModel = createTrainingViewModel(trainingType: .revising(categoryId: 0))
        trainingViewModel.loadData()
        
        XCTAssertEqual(0, mockWordDao.usedWordsFilter?.0)
        XCTAssertEqual(Filter.learned, mockWordDao.usedWordsFilter?.1)
        XCTAssertEqual(1, trainingViewModel.stepNumber)
        XCTAssertEqual("definition of cat", trainingViewModel.definition)
        XCTAssertEqual([TrainingAnswer(answer: "cat", correct: true), TrainingAnswer(answer: "dog", correct: false)],
                       trainingViewModel.answers)
        XCTAssertFalse(trainingViewModel.answerButtonsDisabled)
        XCTAssertTrue(trainingViewModel.nextButtonDisabled)
        XCTAssertEqual(TrainingButtonType.next, trainingViewModel.buttonType)
        XCTAssertEqual(0, trainingViewModel.createTrainingResult().numberOfRightAnswers)
    }
    
    func testAnswerChosen_CorrectAnswer() throws {
        let trainingViewModel = createTrainingViewModel(trainingType: .learningAll)
        trainingViewModel.loadData()
        trainingViewModel.answerChosen(answer: TrainingAnswer(answer: "cat", correct: true))
        
        XCTAssertEqual(1, trainingViewModel.stepNumber)
        XCTAssertEqual("definition of cat", trainingViewModel.definition)
        XCTAssertTrue(trainingViewModel.answerButtonsDisabled)
        XCTAssertFalse(trainingViewModel.nextButtonDisabled)
        XCTAssertEqual(TrainingButtonType.next, trainingViewModel.buttonType)
        XCTAssertEqual(1, trainingViewModel.createTrainingResult().numberOfRightAnswers)
        
        XCTAssertEqual(0, mockWordDao.updatedWordId)
    }
    
    func testAnswerChosen_IncorrectAnswer() throws {
        let trainingViewModel = createTrainingViewModel(trainingType: .learningAll)
        trainingViewModel.loadData()
        trainingViewModel.answerChosen(answer: TrainingAnswer(answer: "dog", correct: false))
        
        XCTAssertEqual(1, trainingViewModel.stepNumber)
        XCTAssertEqual("definition of cat", trainingViewModel.definition)
        XCTAssertTrue(trainingViewModel.answerButtonsDisabled)
        XCTAssertFalse(trainingViewModel.nextButtonDisabled)
        XCTAssertEqual(TrainingButtonType.next, trainingViewModel.buttonType)
        XCTAssertEqual(0, trainingViewModel.createTrainingResult().numberOfRightAnswers)
        
        XCTAssertNil(mockWordDao.updatedWordId)
    }
    
    func testNextTapped() {
        let trainingViewModel = createTrainingViewModel(trainingType: .learningAll)
        trainingViewModel.loadData()
        trainingViewModel.answerChosen(answer: TrainingAnswer(answer: "cat", correct: true))
        trainingViewModel.nextTapped()
        
        XCTAssertEqual(2, trainingViewModel.stepNumber)
        XCTAssertEqual("definition of dog", trainingViewModel.definition)
        XCTAssertFalse(trainingViewModel.answerButtonsDisabled)
        XCTAssertTrue(trainingViewModel.nextButtonDisabled)
        XCTAssertEqual(TrainingButtonType.finish, trainingViewModel.buttonType)
        XCTAssertEqual(1, trainingViewModel.createTrainingResult().numberOfRightAnswers)
    }
    
    private func createTrainingViewModel(trainingType: TrainingType) -> TrainingViewModel {
        return TrainingViewModel(
            trainingType: trainingType,
            wordDao: mockWordDao,
            trainingInfoMaker: mockTrainingInfoMaker,
            trainingSettingsStorage: mockTrainingSettingsStorage
        )
    }
}
