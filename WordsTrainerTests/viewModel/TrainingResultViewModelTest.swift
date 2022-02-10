//
//  TrainingResultViewModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 26.01.2022.
//

import XCTest
@testable import WordsTrainer

class TrainingResultViewModelTest: XCTestCase {
    private var mockWordDao: MockWordDao!
    private var mockTrainingSettingsStorage: MockTrainingSettingsStorage!
    
    override func setUp() {
        mockWordDao = MockWordDao()
        mockTrainingSettingsStorage = MockTrainingSettingsStorage(
            trainingSettings: TrainingSettings(numberOfSteps: 5, numberOfAnswers: 4, learnedWordBound: 100)
        )
    }
    
    func testLoadWords_EmptyTrainingResult() throws {
        let viewModel = createViewModel(wordIds: [], numberOfRightAnswers: 0)
        viewModel.loadWords()
        XCTAssertEqual([], viewModel.words)
        XCTAssertEqual(0, viewModel.rightAnswers)
        XCTAssertEqual(5, viewModel.wrongAnswers)
    }
    
    func testLoadWords_Success() throws {
        mockWordDao.words = [
            WordItem.createWordItem(id: 0, word: "cat", rightAnswers: 3),
            WordItem.createWordItem(id: 1, word: "dog", rightAnswers: 57)
        ]
        let words = [
            WordRowInfo(id: 0, word: "cat", definition: "definition of cat", wordStatus: .new),
            WordRowInfo(id: 1, word: "dog", definition: "definition of dog", wordStatus: .halfLearned),
        ]
        let viewModel = createViewModel(wordIds: [0, 1], numberOfRightAnswers: 4)
        viewModel.loadWords()
        XCTAssertEqual(words, viewModel.words)
        XCTAssertEqual(4, viewModel.rightAnswers)
        XCTAssertEqual(1, viewModel.wrongAnswers)
    }
    
    private func createViewModel(wordIds: [Int], numberOfRightAnswers: Int) -> TrainingResultViewModel {
        return TrainingResultViewModel(
            trainingResult: TrainingResult(wordIds: wordIds, numberOfRightAnswers: numberOfRightAnswers),
            wordDao: mockWordDao,
            trainingSettingsStorage: mockTrainingSettingsStorage
        )
    }
}
