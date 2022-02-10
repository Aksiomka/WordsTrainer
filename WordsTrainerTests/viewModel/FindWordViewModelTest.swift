//
//  FindWordViewModelTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import XCTest
@testable import WordsTrainer

class FindWordViewModelTest: XCTestCase {
    private let wordModels = [
        WordApiModel(
            word: "word",
            phonetics: [Phonetics(text: "wəːd", audio: "")],
            meanings: [
                Meaning(
                    partOfSpeech: "noun",
                    definitions: [
                        Definition(
                            definition: "a single distinct meaningful element of speech or writing",
                            example: "I don't like the word ‘unofficial’",
                            synonyms: ["term", "name"]
                        ),
                        Definition(
                            definition: "a command, password or signal",
                            example: "he gave me the word to start playing",
                            synonyms: ["order", "command"]
                        )
                    ]
                ),
                Meaning(
                    partOfSpeech: "noun",
                    definitions: [
                        Definition(
                            definition: "one's account of the truth",
                            example: "in court it would have been his word against mine",
                            synonyms: []
                        )
                    ]
                )
            ]
        ),
        WordApiModel(
            word: "word",
            phonetics: [Phonetics(text: "wəːd", audio: nil)],
            meanings: [
                Meaning(
                    partOfSpeech: "verb",
                    definitions: [
                        Definition(
                            definition: "express (something spoken or written) in particular words",
                            example: nil,
                            synonyms: []
                        )
                    ]
                )
            ]
        )
    ]
    
    private let wordDescriptions = [
        WordDescription(
            word: "word",
            phonetic: "wəːd",
            partOfSpeech: "noun",
            definition: "a single distinct meaningful element of speech or writing",
            example: "I don't like the word ‘unofficial’",
            synonyms: ["term", "name"]
        ),
        WordDescription(
            word: "word",
            phonetic: "wəːd",
            partOfSpeech: "noun",
            definition: "a command, password or signal",
            example: "he gave me the word to start playing",
            synonyms: ["order", "command"]
        ),
        WordDescription(
            word: "word",
            phonetic: "wəːd",
            partOfSpeech: "noun",
            definition: "one's account of the truth",
            example: "in court it would have been his word against mine",
            synonyms: []
        ),
        WordDescription(
            word: "word",
            phonetic: "wəːd",
            partOfSpeech: "verb",
            definition: "express (something spoken or written) in particular words",
            example: "",
            synonyms: []
        )
    ]
    
    private var mockWordsService: MockWordsService!
    
    override func setUp() {
        mockWordsService = MockWordsService()
        mockWordsService.wordModels = wordModels
    }
    
    func testValidate_Valid() throws {
        let viewModel = FindWordViewModel(categoryId: 0, wordsService: mockWordsService)
        viewModel.word = "word"
        viewModel.validate()
        XCTAssertFalse(viewModel.findButtonDisabled)
    }
    
    func testValidate_EmptyWord() throws {
        let viewModel = FindWordViewModel(categoryId: 0, wordsService: mockWordsService)
        viewModel.word = ""
        viewModel.validate()
        XCTAssertTrue(viewModel.findButtonDisabled)
    }
    
    func testValidate_WordOfWhitespaces() throws {
        let viewModel = FindWordViewModel(categoryId: 0, wordsService: mockWordsService)
        viewModel.word = "    \n"
        viewModel.validate()
        XCTAssertTrue(viewModel.findButtonDisabled)
    }
    
    func testFindWord_InProgress() throws {
        let viewModel = FindWordViewModel(categoryId: 0, wordsService: mockWordsService)
        viewModel.word = "word"
        viewModel.findWord()
        XCTAssertTrue(viewModel.loading)
        XCTAssertFalse(viewModel.errorOccured)
        XCTAssertEqual([], viewModel.wordDescriptions)
    }
    
    func testFindWord_Success() throws {
        let viewModel = FindWordViewModel(categoryId: 0, wordsService: mockWordsService)
        
        let expectation = XCTestExpectation()
        viewModel.taskCompletionHandler = {
            expectation.fulfill()
        }
        
        viewModel.word = "word"
        viewModel.findWord()
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertFalse(viewModel.loading)
        XCTAssertFalse(viewModel.errorOccured)
        XCTAssertEqual(wordDescriptions, viewModel.wordDescriptions)
    }
    
    func testFindWord_Error() throws {
        mockWordsService.throwsError = true
        let viewModel = FindWordViewModel(categoryId: 0, wordsService: mockWordsService)
        
        let expectation = XCTestExpectation()
        viewModel.taskCompletionHandler = {
            expectation.fulfill()
        }
        
        viewModel.word = "word"
        viewModel.findWord()
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertFalse(viewModel.loading)
        XCTAssertTrue(viewModel.errorOccured)
        XCTAssertEqual([], viewModel.wordDescriptions)
    }
}
