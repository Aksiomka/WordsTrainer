//
//  MockWordsService.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 30.01.2022.
//

import Foundation
@testable import WordsTrainer

class MockWordsService: WordsServiceProtocol {
    var wordModels: [WordApiModel] = []
    var throwsError = false
    
    func getWordDescription(word: String) async throws -> [WordApiModel] {
        if throwsError {
            throw WordsServiceError.parsingError
        }
        return wordModels
    }
}
