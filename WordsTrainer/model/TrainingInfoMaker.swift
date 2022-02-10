//
//  TrainingInfoMaker.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

protocol TrainingInfoMakerProtocol {
    func makeTrainingInfo(words: [Word], trainingSettings: TrainingSettings) -> TrainingInfo
}

class TrainingInfoMaker {
    private let randomGenerator: RandomGeneratorProtocol
    
    init(randomGenerator: RandomGeneratorProtocol) {
        self.randomGenerator = randomGenerator
    }
}

extension TrainingInfoMaker: TrainingInfoMakerProtocol {
    func makeTrainingInfo(words: [Word], trainingSettings: TrainingSettings) -> TrainingInfo {
        guard words.count >= trainingSettings.numberOfSteps,
              words.count >= trainingSettings.numberOfAnswers else {
            return TrainingInfo(words: [])
        }
        
        let wordsToTrain = chooseWordsToTrain(words: words, numberOfSteps: trainingSettings.numberOfSteps)
        var trainingWords: [TrainingStepInfo] = []
        for wordToTrain in wordsToTrain {
            let answers = makeAnswers(word: wordToTrain, allWords: words, numberOfAnswers: trainingSettings.numberOfAnswers)
            trainingWords.append(TrainingStepInfo(wordId: wordToTrain.id, definition: wordToTrain.definition, answers: answers))
        }
        return TrainingInfo(words: trainingWords)
    }
}

private extension TrainingInfoMaker {
    func chooseWordsToTrain(words: [Word], numberOfSteps: Int) -> [Word] {
        var wordIdsToTrain: [Int] = []
        while wordIdsToTrain.count < numberOfSteps {
            let randomWord = getRandomWord(words: words)
            if !wordIdsToTrain.contains(randomWord.id) {
                wordIdsToTrain.append(randomWord.id)
            }
        }
        return wordIdsToTrain.compactMap { wordId in words.first(where: { $0.id == wordId }) }
    }
    
    func makeAnswers(word: Word, allWords: [Word], numberOfAnswers: Int) -> [TrainingAnswer] {
        var answers: [String] = []
        var result: [TrainingAnswer] = []
        let rightAnswer = word.word
        while answers.count < numberOfAnswers - 1 {
            let randomWord = getRandomWord(words: allWords)
            let answerString = randomWord.word
            let answer = TrainingAnswer(answer: answerString, correct: false)
            if !answers.contains(answerString) && answerString != rightAnswer {
                answers.append(answerString)
                result.append(answer)
            }
        }
        let randomIndex = randomGenerator.getRandomInt(maxInt: numberOfAnswers - 1)
        result.insert(TrainingAnswer(answer: rightAnswer, correct: true), at: randomIndex)
        return result
    }
    
    func getRandomWord(words: [Word]) -> Word {
        let randomIndex = randomGenerator.getRandomInt(maxInt: words.count - 1)
        return words[randomIndex]
    }
    
    func getRandomBool() -> Bool {
        let randomIndex = randomGenerator.getRandomInt(maxInt: 1)
        return randomIndex == 0 ? false : true
    }
}
