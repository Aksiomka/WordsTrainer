//
//  AddCategoryViewModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import XCTest
@testable import WordsTrainer

class AddCategoryViewModelTest: XCTestCase {
    private var mockCategoryDao: MockCategoryDao!
    
    override func setUp() {
        mockCategoryDao = MockCategoryDao()
    }
    
    func testInit() throws {
        let viewModel = AddCategoryViewModel(categoryDao: mockCategoryDao)
        XCTAssertTrue(viewModel.saveButtonDisabled)
    }
    
    func testValidate_EmptyName() throws {
        let viewModel = AddCategoryViewModel(categoryDao: mockCategoryDao)
        viewModel.name = ""
        viewModel.validate()
        XCTAssertTrue(viewModel.saveButtonDisabled)
    }
    
    func testValidate_NameOfWhitespaces() throws {
        let viewModel = AddCategoryViewModel(categoryDao: mockCategoryDao)
        viewModel.name = "   \n"
        viewModel.validate()
        XCTAssertTrue(viewModel.saveButtonDisabled)
    }
    
    func testValidate_CorrectName() throws {
        let viewModel = AddCategoryViewModel(categoryDao: mockCategoryDao)
        viewModel.name = "Category"
        viewModel.validate()
        XCTAssertFalse(viewModel.saveButtonDisabled)
    }
    
    func testAddCategory() throws {
        let viewModel = AddCategoryViewModel(categoryDao: mockCategoryDao)
        viewModel.name = "Cat"
        viewModel.saveCategory()
        XCTAssertEqual("Cat", mockCategoryDao.addedCategoryName)
    }
}
