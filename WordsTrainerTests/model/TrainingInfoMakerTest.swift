//
//  TrainingInfoMakerTest.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 25.01.2022.
//

import XCTest
@testable import WordsTrainer

class TrainingInfoMakerTest: XCTestCase {
    private var randomGenerator: MockRandomGenerator!
    private var trainingInfoMaker: TrainingInfoMaker!
    
    override func setUp() {
        randomGenerator = MockRandomGenerator()
        trainingInfoMaker = TrainingInfoMaker(randomGenerator: randomGenerator)
    }
    
    func testMakeTrainingInfo_FiveWords() throws {
        let words = [
            Word.createWord(id: 0, word: "word"),
            Word.createWord(id: 1, word: "cat"),
            Word.createWord(id: 2, word: "dog"),
            Word.createWord(id: 3, word: "mouse"),
            Word.createWord(id: 4, word: "bird")
        ]
        let trainingSettings = TrainingSettings(numberOfSteps: 3, numberOfAnswers: 2, learnedWordBound: 100)
        let info = trainingInfoMaker.makeTrainingInfo(words: words, trainingSettings: trainingSettings)
        XCTAssertEqual(info, TrainingInfo(words: [
            TrainingStepInfo(wordId: 0, definition: words[0].definition, answers: [
                TrainingAnswer(answer: "word", correct: true),
                TrainingAnswer(answer: "mouse", correct: false)
            ]),
            TrainingStepInfo(wordId: 1, definition: words[1].definition, answers: [
                TrainingAnswer(answer: "cat", correct: true),
                TrainingAnswer(answer: "word", correct: false)
            ]),
            TrainingStepInfo(wordId: 2, definition: words[2].definition, answers: [
                TrainingAnswer(answer: "mouse", correct: false),
                TrainingAnswer(answer: "dog", correct: true)
            ])
        ]))
    }
    
    func testMakeTrainingInfo_EmptyWords() throws {
        let trainingSettings = TrainingSettings(numberOfSteps: 0, numberOfAnswers: 0, learnedWordBound: 100)
        let info = trainingInfoMaker.makeTrainingInfo(words: [], trainingSettings: trainingSettings)
        XCTAssertEqual(info, TrainingInfo(words: []))
    }
    
    func testMakeTrainingInfo_BigNumberOfSteps() throws {
        let trainingSettings = TrainingSettings(numberOfSteps: 3, numberOfAnswers: 2, learnedWordBound: 100)
        let info = trainingInfoMaker.makeTrainingInfo(
            words: [
                Word.createWord(id: 0, word: "word"),
                Word.createWord(id: 1, word: "cat")
            ],
            trainingSettings: trainingSettings
        )
        XCTAssertEqual(info, TrainingInfo(words: []))
    }
    
    func testMakeTrainingInfo_BigNumberOfAnswers() throws {
        let trainingSettings = TrainingSettings(numberOfSteps: 2, numberOfAnswers: 3, learnedWordBound: 100)
        let info = trainingInfoMaker.makeTrainingInfo(
            words: [
                Word.createWord(id: 0, word: "word"),
                Word.createWord(id: 1, word: "cat")
            ],
            trainingSettings: trainingSettings
        )
        XCTAssertEqual(info, TrainingInfo(words: []))
    }
}

class MockRandomGenerator: RandomGeneratorProtocol {
    private var counter = -1
    
    func getRandomInt(maxInt: Int) -> Int {
        counter += 1
        return counter % (maxInt + 1)
    }
}
