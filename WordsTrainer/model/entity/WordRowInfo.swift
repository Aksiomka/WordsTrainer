//
//  WordRowInfo.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 03.02.2022.
//

import Foundation

enum WordStatus {
    case learned
    case halfLearned
    case new
    
    static func create(rightAnswers: Int, trainingSettings: TrainingSettings) -> WordStatus {
        if rightAnswers >= trainingSettings.learnedWordBound {
            return .learned
        } else if rightAnswers >= trainingSettings.learnedWordBound / 2 {
            return .halfLearned
        } else {
            return .new
        }
    }
}

struct WordRowInfo: Equatable {
    let id: Int
    let word: String
    let definition: String
    let wordStatus: WordStatus
}
