//
//  WordsTrainerWidgetViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 21.01.2022.
//

import Foundation
import WidgetKit
import SwiftUI

class WordsTrainerWidgetViewModel: ObservableObject, TimelineEntry {
    var date: Date
    @Published var word: Word
    
    public init(date: Date, word: Word?) {
        self.date = date
        self.word = word ?? Word.createEmptyWord()
    }
}
