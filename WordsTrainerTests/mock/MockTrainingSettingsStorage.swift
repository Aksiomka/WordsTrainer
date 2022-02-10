//
//  MockTrainingSettingsStorage.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import Foundation
@testable import WordsTrainer

class MockTrainingSettingsStorage: TrainingSettingsStorageProtocol {
    private let trainingSettings: TrainingSettings
    
    init(trainingSettings: TrainingSettings) {
        self.trainingSettings = trainingSettings
    }
    
    func saveSettings(_ settings: TrainingSettings) {}
    
    func loadSettings() -> TrainingSettings {
        return trainingSettings
    }
}
