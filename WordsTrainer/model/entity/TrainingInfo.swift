//
//  TrainingInfo.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

struct TrainingInfo: Equatable {
    let words: [TrainingStepInfo]
}

struct TrainingStepInfo: Equatable {
    let wordId: Int
    let definition: String
    let answers: [TrainingAnswer]
}

struct TrainingAnswer: Equatable, Hashable {
    let answer: String
    let correct: Bool
}
