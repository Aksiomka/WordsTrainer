//
//  AddWordModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import XCTest
@testable import WordsTrainer

class AddWordModelTest: XCTestCase {
    private var mockWordDao: MockWordDao!
    
    private let wordDescription = WordDescription(
        word: "word",
        phonetic: "word",
        partOfSpeech: "noun",
        definition: "definition of word",
        example: "some example",
        synonyms: ["synonym1", "synonym2", "synonym3"]
    )
    
    override func setUp() {
        mockWordDao = MockWordDao()
    }
    
    func testInit() throws {
        let viewModel = createViewModel()
        XCTAssertEqual("word", viewModel.word)
        XCTAssertEqual("word", viewModel.phonetic)
        XCTAssertEqual("noun", viewModel.partOfSpeech)
        XCTAssertEqual("definition of word", viewModel.definition)
        XCTAssertEqual("some example", viewModel.example)
        XCTAssertEqual("synonym1, synonym2, synonym3", viewModel.synonyms)
        XCTAssertFalse(viewModel.saveButtonDisabled)
    }
    
    func testValidate_EmptyWord() throws {
        let viewModel = createViewModel()
        viewModel.word = ""
        XCTAssertTrue(viewModel.saveButtonDisabled)
    }
    
    func testValidate_WordOfWhitespaces() throws {
        let viewModel = createViewModel()
        viewModel.word = "   \n"
        XCTAssertTrue(viewModel.saveButtonDisabled)
    }
    
    func testValidate_EmptyDefinition() throws {
        let viewModel = createViewModel()
        viewModel.definition = ""
        XCTAssertTrue(viewModel.saveButtonDisabled)
    }
    
    func testValidate_DefinitionOfWhitespaces() throws {
        let viewModel = createViewModel()
        viewModel.definition = "   \n"
        XCTAssertTrue(viewModel.saveButtonDisabled)
    }
    
    func testValidate_CorrectWordAndDefinition() throws {
        let viewModel = createViewModel()
        viewModel.word = "cat"
        viewModel.definition = "definition of cat"
        XCTAssertFalse(viewModel.saveButtonDisabled)
    }
    
    func testAddCategory() throws {
        let viewModel = createViewModel()
        viewModel.saveWord()
        let word = Word(
            id: 0,
            categoryId: 0,
            word: "word",
            definition: "definition of word",
            phonetic: "word",
            example: "some example",
            partOfSpeech: "noun",
            synonyms: "synonym1, synonym2, synonym3",
            rightAnswers: 0
        )
        XCTAssertEqual(word, mockWordDao.addedWord)
    }
    
    private func createViewModel() -> AddWordViewModel {
        return AddWordViewModel(
            categoryId: 0,
            wordDescription: wordDescription,
            wordDao: mockWordDao
        )
    }
}
