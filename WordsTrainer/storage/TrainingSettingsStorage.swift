//
//  TrainingSettingsStorage.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import Foundation

protocol TrainingSettingsStorageProtocol {
    func saveSettings(_ settings: TrainingSettings)
    func loadSettings() -> TrainingSettings
}

class TrainingSettingsStorage: TrainingSettingsStorageProtocol {
    private let numberOfStepsKey = "numberOfSteps"
    private let numberOfAnswersKey = "numberOfAnswers"
    private let learnedWordBoundKey = "learnedWordBound"
    
    private let defaultSettings = TrainingSettings(numberOfSteps: 10, numberOfAnswers: 4, learnedWordBound: 100)
    
    func saveSettings(_ settings: TrainingSettings) {
        let userDefaults = UserDefaults.getShared()
        userDefaults.set(settings.numberOfSteps, forKey: numberOfStepsKey)
        userDefaults.set(settings.numberOfAnswers, forKey: numberOfAnswersKey)
        userDefaults.set(settings.learnedWordBound, forKey: learnedWordBoundKey)
    }
    
    func loadSettings() -> TrainingSettings {
        let userDefaults = UserDefaults.getShared()
        let numberOfSteps = userDefaults.integer(forKey: numberOfStepsKey)
        let numberOfAnswers = userDefaults.integer(forKey: numberOfAnswersKey)
        let learnedWordBound = userDefaults.integer(forKey: learnedWordBoundKey)
        if numberOfSteps == 0 || numberOfAnswers == 0 || learnedWordBound == 0 {
            return defaultSettings
        }
        return TrainingSettings(numberOfSteps: numberOfSteps, numberOfAnswers: numberOfAnswers, learnedWordBound: learnedWordBound)
    }
}
