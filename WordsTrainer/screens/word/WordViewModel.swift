//
//  WordViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 19.01.2022.
//

import Foundation
import AVKit

class WordViewModel: ObservableObject {
    private var wordId: Int
    @Published var word = Word.createEmptyWord()
    @Published var categoryName = ""
    @Published var learningProgressPercent = 0
    
    private let wordDao: WordDaoProtocol
    private let categoryDao: CategoryDaoProtocol
    private let trainingSettingsStorage: TrainingSettingsStorageProtocol
    
    init(
        wordId: Int,
        categoryDao: CategoryDaoProtocol,
        wordDao: WordDaoProtocol,
        trainingSettingsStorage: TrainingSettingsStorageProtocol
    ) {
        self.wordId = wordId
        self.wordDao = wordDao
        self.categoryDao = categoryDao
        self.trainingSettingsStorage = trainingSettingsStorage
    }
    
    func loadData() {
        let trainingSettings = trainingSettingsStorage.loadSettings()
        if let wordFromDb = wordDao.getWordById(wordId) {
            word = convertWord(wordFromDb)
            learningProgressPercent = min(word.rightAnswers * 100 / trainingSettings.learnedWordBound, 100)
            categoryName = categoryDao.getCategoryById(wordFromDb.categoryId)?.name ?? ""
        }
    }
    
    func playSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("AVAudioSession error: \(error.localizedDescription)")
        }

        let utterance = AVSpeechUtterance(string: word.word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

private extension WordViewModel {
    func convertWord(_ word: WordItem) -> Word {
        return Word(
            id: word.id,
            categoryId: word.categoryId,
            word: word.word,
            definition: word.definition,
            phonetic: word.phonetic,
            example: word.example,
            partOfSpeech: word.partOfSpeech,
            synonyms: word.synonyms,
            rightAnswers: word.rightAnswers
        )
    }
}
