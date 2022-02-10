//
//  WordViewModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import XCTest
@testable import WordsTrainer

class WordViewModelTest: XCTestCase {
    private var mockCategoryDao: MockCategoryDao!
    private var mockWordDao: MockWordDao!
    private var mockTrainingSettingsStorage: MockTrainingSettingsStorage!
    private let categoryItem = CategoryItem.createCategoryItem(id: 10, name: "Category 1")
    
    override func setUp() {
        mockCategoryDao = MockCategoryDao()
        mockWordDao = MockWordDao()
        mockTrainingSettingsStorage = MockTrainingSettingsStorage(
            trainingSettings: TrainingSettings(numberOfSteps: 5, numberOfAnswers: 4, learnedWordBound: 100)
        )
    }
    
    func testLoadData_WordNotFound() throws {
        let viewModel = createViewModel()
        viewModel.loadData()
        XCTAssertEqual(Word.createEmptyWord(), viewModel.word)
        XCTAssertEqual("", viewModel.categoryName)
        XCTAssertEqual(0, viewModel.learningProgressPercent)
    }
    
    func testLoadData_Success() throws {
        let word = Word(
            id: 0,
            categoryId: 10,
            word: "word",
            definition: "definition of word",
            phonetic: "wo:rd",
            example: "example",
            partOfSpeech: "noun",
            synonyms: "name, letters",
            rightAnswers: 50
        )
        
        let wordItem = WordItem.createWordItem(id: 0, categoryId: 10, word: "word", rightAnswers: 50)
        wordItem.phonetic = "wo:rd"
        wordItem.partOfSpeech = "noun"
        wordItem.example = "example"
        wordItem.synonyms = "name, letters"
        
        mockCategoryDao.category = categoryItem
        mockWordDao.word = wordItem
        
        let viewModel = createViewModel()
        viewModel.loadData()
        XCTAssertEqual(word, viewModel.word)
        XCTAssertEqual("Category 1", viewModel.categoryName)
        XCTAssertEqual(50, viewModel.learningProgressPercent)
    }
    
    func testLoadData_BigRightAnswers() throws {
        let word = Word.createWord(id: 0, categoryId: 10, word: "word", rightAnswers: 150)
        let wordItem = WordItem.createWordItem(id: 0, categoryId: 10, word: "word", rightAnswers: 150)
        
        mockCategoryDao.category = categoryItem
        mockWordDao.word = wordItem
        
        let viewModel = createViewModel()
        viewModel.loadData()
        XCTAssertEqual(word, viewModel.word)
        XCTAssertEqual(100, viewModel.learningProgressPercent)
    }
    
    private func createViewModel() -> WordViewModel {
        return WordViewModel(
            wordId: 0,
            categoryDao: mockCategoryDao,
            wordDao: mockWordDao,
            trainingSettingsStorage: mockTrainingSettingsStorage
        )
    }
}
