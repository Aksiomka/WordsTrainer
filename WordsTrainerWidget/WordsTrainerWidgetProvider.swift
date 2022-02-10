//
//  WordsTrainerWidgetProvider.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 21.01.2022.
//

import WidgetKit
import SwiftUI

struct WordsTrainerWidgetProvider: TimelineProvider {
    private let calendar = Calendar.current
    
    func placeholder(in context: Context) -> WordsTrainerWidgetViewModel {
        return WordsTrainerWidgetViewModel(date: Date(), word: Self.sampleWord)
    }

    func getSnapshot(in context: Context, completion: @escaping (WordsTrainerWidgetViewModel) -> Void) {
        let entry = WordsTrainerWidgetViewModel(date: Date(), word: Self.sampleWord)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WordsTrainerWidgetViewModel>) -> Void) {
        let currentDate = Date()
        guard let refreshDate = calendar.date(byAdding: .hour, value: 4, to: currentDate) else { return }
        
        let wordDao = WordDao()
        let trainingSettings = TrainingSettingsStorage().loadSettings()
        let wordItem = wordDao.getRandomNotLearnedWord(trainingSettings: trainingSettings)
        let entry = WordsTrainerWidgetViewModel(date: Date(), word: convertWordItem(wordItem))
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}

extension WordsTrainerWidgetProvider {
    static var sampleWord: Word {
        return Word(
            id: 0,
            categoryId: 0,
            word: "carrot",
            definition: "a tapering orange-coloured root eaten as a vegetable",
            phonetic: "ˈkarət",
            example: "roast lamb with peas and carrots",
            partOfSpeech: "noun",
            synonyms: "",
            rightAnswers: 0
        )
    }
}

private extension WordsTrainerWidgetProvider {
    func convertWordItem(_ wordItem: WordItem?) -> Word? {
        guard let item = wordItem else { return nil }
        
        return Word(
            id: item.id,
            categoryId: item.categoryId,
            word: item.word,
            definition: item.definition,
            phonetic: item.phonetic,
            example: item.example,
            partOfSpeech: item.partOfSpeech,
            synonyms: item.synonyms,
            rightAnswers: item.rightAnswers
        )
    }
}
