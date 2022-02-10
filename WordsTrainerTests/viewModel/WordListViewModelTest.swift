//
//  WordListViewModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import XCTest
@testable import WordsTrainer

class WordListViewModelTest: XCTestCase {
    private var mockWordDao: MockWordDao!
    private var mockTrainingSettingsStorage: MockTrainingSettingsStorage!
    private var mockWordListSettingsStorage: MockWordListSettingsStorage!
    
    private var wordItems = [
        WordItem.createWordItem(id: 0, categoryId: 10, word: "cat", rightAnswers: 99),
        WordItem.createWordItem(id: 1, categoryId: 10, word: "word", rightAnswers: 98),
        WordItem.createWordItem(id: 2, categoryId: 10, word: "dog", rightAnswers: 100),
        WordItem.createWordItem(id: 3, categoryId: 10, word: "bird", rightAnswers: 101)
    ]
    private var words = [
        WordRowInfo(id: 0, word: "cat", definition: "definition of cat", wordStatus: .halfLearned),
        WordRowInfo(id: 1, word: "word", definition: "definition of word", wordStatus: .halfLearned),
        WordRowInfo(id: 2, word: "dog", definition: "definition of dog", wordStatus: .learned),
        WordRowInfo(id: 3, word: "bird", definition: "definition of bird", wordStatus: .learned)
    ]
    
    override func setUp() {
        mockWordDao = MockWordDao()
        mockTrainingSettingsStorage = MockTrainingSettingsStorage(
            trainingSettings: TrainingSettings(numberOfSteps: 2, numberOfAnswers: 2, learnedWordBound: 100)
        )
        mockWordListSettingsStorage = MockWordListSettingsStorage(sorting: .alphabetically, filter: .all)
    }
    
    func testLoadData_NoWords() throws {
        let viewModel = createViewModel()
        viewModel.onAppear()
        XCTAssertEqual(10, mockWordDao.usedWordsFilter?.0)
        XCTAssertEqual(Filter.all, mockWordDao.usedWordsFilter?.1)
        XCTAssertEqual(Sorting.alphabetically, mockWordDao.usedWordsFilter?.2)
        XCTAssertEqual([], viewModel.words)
        XCTAssertTrue(viewModel.startTrainingButtonDisabled)
        XCTAssertTrue(viewModel.startRevisingButtonDisabled)
    }
    
    func testLoadData_AllWords() throws {
        mockWordDao.words = [wordItems[3], wordItems[0], wordItems[2], wordItems[1]]
        mockWordDao.wordsCount = 4
        let viewModel = createViewModel()
        viewModel.onAppear()
        XCTAssertEqual(10, mockWordDao.usedWordsFilter?.0)
        XCTAssertEqual(Filter.all, mockWordDao.usedWordsFilter?.1)
        XCTAssertEqual(Sorting.alphabetically, mockWordDao.usedWordsFilter?.2)
        XCTAssertEqual([words[3], words[0], words[2], words[1]], viewModel.words)
        XCTAssertFalse(viewModel.startTrainingButtonDisabled)
        XCTAssertFalse(viewModel.startRevisingButtonDisabled)
    }
    
    func testOnSortingChanged() throws {
        mockWordDao.words = wordItems
        let viewModel = createViewModel()
        viewModel.onAppear()
        mockWordDao.words = [wordItems[1], wordItems[0], wordItems[2], wordItems[3]]
        viewModel.onSortingChanged(sorting: .byProgress)
        
        XCTAssertEqual(Sorting.byProgress, mockWordListSettingsStorage.savedSorting)
        XCTAssertEqual([words[1], words[0], words[2], words[3]], viewModel.words)
        XCTAssertEqual(10, mockWordDao.usedWordsFilter?.0)
        XCTAssertEqual(Filter.all, mockWordDao.usedWordsFilter?.1)
        XCTAssertEqual(Sorting.byProgress, mockWordDao.usedWordsFilter?.2)
    }
    
    func testOnFilterChanged() throws {
        mockWordDao.words = []
        let viewModel = createViewModel()
        viewModel.onAppear()
        mockWordDao.words = [wordItems[3], wordItems[2]]
        viewModel.onFilterChanged(filter: .learned)
        
        XCTAssertEqual(Filter.learned, mockWordListSettingsStorage.savedFilter)
        XCTAssertEqual(10, mockWordDao.usedWordsFilter?.0)
        XCTAssertEqual(Filter.learned, mockWordDao.usedWordsFilter?.1)
        XCTAssertEqual(Sorting.alphabetically, mockWordDao.usedWordsFilter?.2)
        XCTAssertEqual([words[3], words[2]], viewModel.words)
    }
    
    func testDeleteWord_Success() throws {
        mockWordDao.words = [wordItems[0], wordItems[1], wordItems[2]]
        let viewModel = createViewModel()
        viewModel.onAppear()
        viewModel.deleteWords(indexes: IndexSet(integersIn: 1...1))
        XCTAssertEqual(1, mockWordDao.deletedWordId)
    }
    
    func testDeleteWord_WrongIndex() throws {
        mockWordDao.words = [wordItems[0], wordItems[1]]
        let viewModel = createViewModel()
        viewModel.onAppear()
        viewModel.deleteWords(indexes: IndexSet(integersIn: 2...2))
        XCTAssertNil(mockWordDao.deletedWordId)
    }
    
    private func createViewModel() -> WordListViewModel {
        return WordListViewModel(
            categoryId: 10,
            wordDao: mockWordDao,
            wordListSettingsStorage: mockWordListSettingsStorage,
            trainingSettingsStorage: mockTrainingSettingsStorage
        )
    }
}
