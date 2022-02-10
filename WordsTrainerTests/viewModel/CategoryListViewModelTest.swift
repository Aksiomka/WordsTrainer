//
//  CategoryListViewModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import XCTest
@testable import WordsTrainer

class CategoryListViewModelTest: XCTestCase {
    private var mockCategoryDao: MockCategoryDao!
    private var mockWordDao: MockWordDao!
    private var mockTrainingSettingsStorage: MockTrainingSettingsStorage!
    
    override func setUp() {
        mockCategoryDao = MockCategoryDao()
        mockWordDao = MockWordDao()
        mockTrainingSettingsStorage = MockTrainingSettingsStorage(
            trainingSettings: TrainingSettings(numberOfSteps: 2, numberOfAnswers: 2, learnedWordBound: 100)
        )
    }
    
    func testLoadData_NoCategories() throws {
        let viewModel = createViewModel()
        viewModel.onAppear()
        XCTAssertEqual([], viewModel.categories)
        XCTAssertTrue(viewModel.startTrainingButtonDisabled)
        XCTAssertTrue(viewModel.startRevisingButtonDisabled)
    }
    
    func testLoadData_Success() throws {
        let category1 = Category(id: 10, name: "Category 1")
        let category2 = Category(id: 20, name: "Category 2")
        
        let categoryItem1 = CategoryItem.createCategoryItem(id: 10, name: "Category 1")
        let categoryItem2 = CategoryItem.createCategoryItem(id: 20, name: "Category 2")
        
        mockCategoryDao.categories = [categoryItem1, categoryItem2]
        mockWordDao.wordsCount = 20
        
        let viewModel = createViewModel()
        viewModel.onAppear()
        XCTAssertEqual([category1, category2], viewModel.categories)
        XCTAssertFalse(viewModel.startTrainingButtonDisabled)
        XCTAssertFalse(viewModel.startRevisingButtonDisabled)
    }
    
    func testDeleteCategory_Success() throws {
        let categoryItem1 = CategoryItem.createCategoryItem(id: 10, name: "Category 1")
        let categoryItem2 = CategoryItem.createCategoryItem(id: 20, name: "Category 2")
        let categoryItem3 = CategoryItem.createCategoryItem(id: 30, name: "Category 3")
        
        mockCategoryDao.categories = [categoryItem1, categoryItem2, categoryItem3]
        
        let viewModel = createViewModel()
        viewModel.onAppear()
        viewModel.deleteCategories(indexes: IndexSet(integersIn: 1...1))
        XCTAssertEqual(20, mockCategoryDao.deletedCategoryId)
        XCTAssertEqual(20, mockWordDao.deletedWordsCategoryId)
    }
    
    func testDeleteCategory_WrongIndex() throws {
        let categoryItem1 = CategoryItem.createCategoryItem(id: 10, name: "Category 1")
        let categoryItem2 = CategoryItem.createCategoryItem(id: 20, name: "Category 2")
        
        mockCategoryDao.categories = [categoryItem1, categoryItem2]
        
        let viewModel = createViewModel()
        viewModel.onAppear()
        viewModel.deleteCategories(indexes: IndexSet(integersIn: 2...2))
        XCTAssertNil(mockCategoryDao.deletedCategoryId)
        XCTAssertNil(mockWordDao.deletedWordsCategoryId)
    }
    
    private func createViewModel() -> CategoryListViewModel {
        return CategoryListViewModel(
            categoryDao: mockCategoryDao,
            wordDao: mockWordDao,
            trainingSettingsStorage: mockTrainingSettingsStorage
        )
    }
}
