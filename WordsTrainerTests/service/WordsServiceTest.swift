//
//  WordsServiceTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 30.01.2022.
//

import XCTest
@testable import WordsTrainer

class WordsServiceTest: XCTestCase {
    var wordsService: WordsService!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)

        wordsService = WordsService(urlSession: urlSession)
    }

    func testGetWordDescription_SuccessfulResponse() async throws {
        let jsonString = """
        [{
            "word":"hello",
            "phonetic":"həˈləʊ",
            "phonetics":[
                {"text":"həˈləʊ","audio":"//ssl.gstatic.com/dictionary/static/sounds/20200429/hello--_gb_1.mp3"},
                {"text":"hɛˈləʊ"}
            ],
            "origin":"early 19th century: variant of earlier hollo",
            "meanings": [{
                "partOfSpeech":"noun",
                "definitions":[{
                    "definition":"used as a greeting or to begin a phone conversation.",
                    "example":"hello there, Katie!",
                    "synonyms":["hi"],
                    "antonyms":[]
                }, {
                    "definition":"an utterance of ‘hello’; a greeting.",
                    "example":"she was getting polite nods and hellos from people",
                    "synonyms":[],
                }
            ]}, {
                "definitions":[{
                    "definition":"say or shout ‘hello’.",
                    "synonyms":[],
                    "antonyms":[]}]
            }]
        }]
        """
        let data = jsonString.data(using: .utf8)
        
        let expectedModels = [
            WordApiModel(
                word: "hello",
                phonetics: [
                    Phonetics(text: "həˈləʊ", audio: "//ssl.gstatic.com/dictionary/static/sounds/20200429/hello--_gb_1.mp3"),
                    Phonetics(text: "hɛˈləʊ", audio: nil)
                ], meanings: [
                    Meaning(
                        partOfSpeech: "noun",
                        definitions: [
                            Definition(
                                definition: "used as a greeting or to begin a phone conversation.",
                                example: "hello there, Katie!",
                                synonyms: ["hi"]
                            ),
                            Definition(
                                definition: "an utterance of ‘hello’; a greeting.",
                                example: "she was getting polite nods and hellos from people",
                                synonyms: []
                            )
                        ]
                    ),
                    Meaning(
                        partOfSpeech: nil,
                        definitions: [
                            Definition(
                                definition: "say or shout ‘hello’.",
                                example: nil,
                                synonyms: []
                            )
                        ]
                    )
                ]
            )
        ]
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/hello")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        let wordsModels = try await wordsService.getWordDescription(word: "hello")
        XCTAssertEqual(expectedModels, wordsModels)
    }
    
    func testGetWordDescription_ParsingFailure() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/hello")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = Data()
            return (response, data)
        }
        
        do {
            _ = try await wordsService.getWordDescription(word: "hello")
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? WordsServiceError, WordsServiceError.parsingError)
        }
    }
    
    func testGetWordDescription_InvalidResponse() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/hello")!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = Data()
            return (response, data)
        }
        
        do {
            _ = try await wordsService.getWordDescription(word: "hello")
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? WordsServiceError, WordsServiceError.invalidResponse)
        }
    }
}
