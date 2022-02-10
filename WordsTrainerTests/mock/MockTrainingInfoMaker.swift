//
//  MockTrainingInfoMaker.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 30.01.2022.
//

import Foundation
@testable import WordsTrainer

class MockTrainingInfoMaker: TrainingInfoMakerProtocol {
    private let trainingInfo: TrainingInfo
    
    init(trainingInfo: TrainingInfo) {
        self.trainingInfo = trainingInfo
    }
    
    func makeTrainingInfo(words: [Word], trainingSettings: TrainingSettings) -> TrainingInfo {
        return trainingInfo
    }
}
